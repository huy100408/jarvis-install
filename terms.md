Version: 2026-11-13
# JARVIS Terms of Service and Privacy Policy

These terms apply to every version of JARVIS: the Mac app, the Windows app, the iPhone and iPad app, the command-line tools, the cloud service behind them and the download website. Please read them before you install or use JARVIS. By choosing **I Agree**, or by downloading, installing or using JARVIS, you accept these terms. If you do not agree, do not download or use JARVIS.

## Part 1: Terms of Service

## 1. What JARVIS is

JARVIS is an AI assistant that runs on your own computer. When you ask it to, it can:
- see your screen (screenshots and the accessibility tree);
- move the mouse, type on the keyboard and open apps;
- run shell commands, scripts and AppleScript;
- search the web, read and write files, and answer you out loud;
- stream your computer's screen to your own iPhone or iPad over your local network or Tailscale.

Sensitive actions, such as entering passwords, payments, keychain access and destructive commands, pause and wait for your approval. You can approve or deny each one.

## 2. Your responsibility

- **You are in control.** JARVIS acts on your instructions on your computer. You are responsible for what you ask it to do and for every action you approve.
- **AI makes mistakes.** Answers can be wrong, out of date or incomplete, and an automated action can click the wrong thing. Check important results yourself, and read every approval request before you approve it.
- **Keep backups.** We are not responsible for lost files, data or settings caused by actions you asked for or approved.
- Do not use JARVIS for medical, legal, financial or safety-critical decisions without checking with a qualified person.

## 3. Who can use JARVIS

You must be at least 16 years old, or have permission from a parent or guardian who accepts these terms for you. You must have the right to control every computer and device you connect to JARVIS.

## 4. Accounts

- You sign in with your Google account, or continue as a guest where the app allows it.
- Keep your account and devices secure. You are responsible for activity on your account.
- One account is for one person. Do not share, sell or transfer it, except through the Family feature described below.

## 5. Plans and payments

- **Free:** 5 cloud messages per day and 30 per month. Limits may change; the app always shows your current limit.
- **Pro & Family:** 300.000đ. Pro gives the owner unlimited requests for the period shown in the app when you pay. The owner can invite up to 5 family members, who share a pool of 3,000 tasks per month. The owner is responsible for the members they invite.
- You pay by bank transfer through MoMo, VietQR or Napas 247, using the transfer reference shown in the app. We check each payment and turn on Pro after it is confirmed. A payment with a wrong amount or reference may take longer to confirm or may be rejected.
- Payments are not refundable, except when we could not turn on Pro for a confirmed payment, or where the law requires a refund. If something went wrong with a payment, contact us (see section 15).
- If you use your own AI provider key, that provider bills you directly under its own terms. We do not see or control those charges.

## 6. Acceptable use

You must not:
- use JARVIS for anything illegal, or to harm, harass, spy on or defraud anyone;
- control, watch or access a computer or device that you are not allowed to;
- create or spread malware, spam, or content that breaks the law;
- get around usage limits, payments or bans, or abuse the free plan with multiple accounts;
- attack, overload, reverse engineer or resell the JARVIS cloud service;
- remove or change the approval gate in order to harm yourself or others.

## 7. Suspension and bans

We may limit, suspend or ban an account that breaks these terms, makes fraudulent payments, or uses a modified copy of JARVIS to get around limits. Where we can, we tell you the reason in the app. You can stop using JARVIS at any time and uninstall it.

## 8. Third-party services

JARVIS works with services run by other companies, including Google (sign-in), Supabase (accounts), AI model providers (such as Anthropic, OpenAI, Google and the AI gateway behind the free cloud chat), voice services (such as Fish Audio), weather, maps and location services (such as Open-Meteo, ipinfo.io and ArcGIS), and GitHub (downloads and updates). Those services have their own terms and privacy policies. We are not responsible for them, and they may change or stop working.

## 9. Software, updates and integrity checks

- We give you a personal, non-exclusive, non-transferable right to install and use JARVIS on devices you own or control. We keep all other rights to JARVIS, its name, logo and design.
- The Mac app checks for updates at most once a day and installs them automatically. You can also run **jarvis update** yourself.
- JARVIS checks that its own files have not been changed. If they have, it may send us an integrity report (see Part 2).
- Some downloads are not signed by Apple or Microsoft, so your system may warn you before opening them. Only download JARVIS from the official site: https://huy100408.github.io/jarvis-install/

## 10. No warranty

JARVIS is provided **"as is"** and **"as available"**. To the fullest extent the law allows, we make no promises that it will be error-free, secure, always available, or fit for a particular purpose.

## 11. Limitation of liability

To the fullest extent the law allows, we are not liable for indirect, incidental or consequential damages, or for lost data, files, profits or business, that come from using or not being able to use JARVIS, including actions JARVIS took on your instructions or with your approval. Our total liability for any claim is limited to the amount you paid us in the 3 months before the claim. Nothing in these terms limits rights that the law does not allow us to limit.

## 12. Ending these terms

You can stop at any time by uninstalling JARVIS (**jarvis uninstall**) and asking us to delete your account. We can end or suspend your access as described in section 7, or stop offering JARVIS. Sections 2, 10, 11 and 14 continue to apply after these terms end.

## 13. Changes to these terms

We may update these terms. When we do, we change the version date at the top, and the app and the download page ask you to accept the new version before you continue. If you do not accept, stop using JARVIS.

## 14. Governing law

These terms are governed by the laws of Vietnam. We will first try to settle any dispute with you informally. If that fails, the dispute goes to a competent court in Vietnam, unless the law where you live gives you a different right.

## 15. Contact

Questions, payment problems, account deletion or privacy requests: open an issue at https://github.com/huy100408/jarvis-install/issues or use the contact option in the app. Do not post passwords, payment details or other private information in a public issue.

## Part 2: Privacy Policy

## 16. The short version

- Most of JARVIS runs on your own computer. Your chat history, settings and keys stay there.
- Our cloud stores only what is needed to run your account: your Google email and name, your plan, usage counts, family membership, payment records and integrity reports.
- When you use AI features, your message, and sometimes a screenshot, is sent to an AI provider to get an answer.
- We do not sell your data and we do not show ads.

## 17. What stays on your device

- Chat history, settings, your chosen name and theme.
- AI provider keys you add yourself. On Mac they are kept in the macOS Keychain.
- Screen recordings and the live screen stream. The stream goes from your computer to your own iPhone or iPad, over your local network or Tailscale, not through our servers.
- Passwords and other secrets you type in the **Secure Input** box. They go straight to the field that needs them and are never sent to the AI model or written to logs.

## 18. What we store in our cloud

When you sign in, our account service (hosted on Supabase) stores:
- your Google account email and name;
- your plan, Pro expiry date, and whether your account is banned and why;
- usage counts, such as cloud messages used today and this month, and family task counts;
- your family group, invite codes and members, if you use Family;
- payment records: amount, bank transfer reference, status and the date it was checked. We do not receive your bank login or card details;
- integrity reports: your app version and the names of any JARVIS files that were changed.

Our cloud chat service keeps short technical logs (for example, your account ID and whether a request succeeded or was refused). It does not save the content of your messages.

## 19. What is sent to other services when you use JARVIS

- **AI providers.** Your messages, the conversation so far, and, when JARVIS needs to look at the screen, screenshots and on-screen text are sent to an AI model to produce an answer. With the free cloud chat, this goes through our cloud service to our AI gateway. With your own key, it goes straight to the provider you chose.
- **Voice.** On Mac, speech recognition uses Apple's speech services. If you use a cloud voice service for spoken replies, the text of the reply is sent to it.
- **Web, weather, maps and location.** Web searches, weather lookups, maps and approximate location from your IP address are sent to the services that answer them.
- **Sign-in.** Google handles sign-in and shares your email and name with us.
- **Downloads and updates** come from GitHub, which can see your IP address.

Each of these services handles your data under its own privacy policy.

## 20. Permissions JARVIS asks for

- **Screen Recording** (Mac) and screen capture, so JARVIS can see what is on the screen.
- **Accessibility** (Mac), so it can move the mouse and type.
- **Microphone and Speech Recognition**, only when you use voice input.
- **Local network** (iPhone and iPad), to connect to your computer.

You can turn these off in your system settings. Some features stop working without them.

## 21. Why we use your data

We use your data only to run JARVIS: to sign you in, apply your plan and limits, confirm payments, run Family, prevent abuse and fraud, check app integrity, fix problems, and meet legal duties. We do not use it for advertising, and we do not sell or rent it.

## 22. How long we keep it

We keep account data while your account exists. Payment records may be kept longer where the law requires it. Data on your device stays until you delete it or uninstall JARVIS. **jarvis uninstall** removes the app, logs, settings, sign-in and saved keys from that computer.

## 23. Your rights

You can ask us to show, correct or delete your personal data, to withdraw your consent, or to stop using your data, including your rights under Vietnam's Decree 13/2023/ND-CP on personal data protection. Withdrawing consent or deleting your account means you can no longer use the cloud features. To make a request, contact us (see section 15).

## 24. Security

We protect your data with access controls on our database, encrypted connections, approval for sensitive actions, and Secure Input for secrets. No system is perfectly secure. If we learn of a breach that affects you, we will tell you as the law requires.

## 25. Children

JARVIS is not meant for children under 16 without a parent's or guardian's permission. If you believe a child has given us data without permission, contact us and we will delete it.

## 26. Changes to this policy

When this policy changes, the version date at the top changes and you are asked to accept it again before you continue.
