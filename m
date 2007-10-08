Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXJHRut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXJHRut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbXJHRum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:50:42 -0400
Received: from web36603.mail.mud.yahoo.com ([209.191.85.20]:42367 "HELO
	web36603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753472AbXJHRul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:50:41 -0400
X-YMail-OSG: LhzG_cYVM1lKURB1G0GvV3UrgYMvzaAtNg8tBYrdptpGbDGc.XmldEg8YAU7TGtI04iuZUa_mg--
X-RocketYMMF: rancidfat
Date: Mon, 8 Oct 2007 10:50:40 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Cc: casey@schaufler-ca.com, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
In-Reply-To: <m1ir5liaoh.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <54877.16343.qm@web36603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Eric W. Biederman" <ebiederm@xmission.com> wrote:


> Likely.  Until we have a generalized LSM interface with 1000 config
> options like netfilter I don't expect we will have grounds to talk
> or agree to a common user space interface.  Although I could be
> wrong.

Gulp. I know that many of you are granularity advocates, but I
have to say that security derived by tweeking 1000 knobs so that
they are all just right seems a little far fetched to me. I see
it as poopooing the 3rd and most important part of the reference
monitor concept, "small enough to analyze". Sure, you can analyse
the 1000 individual checks, but you'll never be able to describe
the system behavior as a whole.


Casey Schaufler
casey@schaufler-ca.com
