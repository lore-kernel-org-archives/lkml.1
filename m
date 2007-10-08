Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbXJHU0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbXJHU0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXJHU0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:26:00 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:38850 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751184AbXJHUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:25:59 -0400
X-YMail-OSG: nVcuBjcVM1mzAXYcg_ZWS.XVGuMqaZ9BfVRUnauY_XDn0FClNxaqQdhQfeWiw3kZWR4uwwmBnw--
X-RocketYMMF: rancidfat
Date: Mon, 8 Oct 2007 13:25:58 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m11wc5a5gp.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <868078.46629.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Eric W. Biederman" <ebiederm@xmission.com> wrote:

> It really seems to me that the LSM as currently structured creates
> a large barrier to entry for people who have just this little thing
> they want to do that is not possible with any existing security
> module.

I honestly think that the barrier has been more political
in nature than technical. I don't know how long you've been
watching, but no attempt to get an LSM upstream has escaped
exagerated cricism from certain factions. Only someone who wants
to get cut to metaphorical ribbons would submit a little LSM.
Maybe that will get better now. I sure hope so.


Casey Schaufler
casey@schaufler-ca.com
