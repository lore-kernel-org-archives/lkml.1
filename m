Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbXJKSyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbXJKSyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 14:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXJKSxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 14:53:54 -0400
Received: from smtpoutm.mac.com ([17.148.16.74]:52150 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbXJKSxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 14:53:53 -0400
In-Reply-To: <928423.71088.qm@web36604.mail.mud.yahoo.com>
References: <928423.71088.qm@web36604.mail.mud.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <7BC13842-3D05-4D80-B521-DD738FE4FB36@mac.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Date: Thu, 11 Oct 2007 14:53:17 -0400
To: casey@schaufler-ca.com
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 11, 2007, at 11:41:34, Casey Schaufler wrote:
> --- Kyle Moffett <mrmacman_g4@mac.com> wrote:
>> [snipped]
>
> I'm still waiting to see the proposed SELinux policy that does what  
> Smack does.

That *is* the SELinux policy which does what Smack does.  I keep  
having bugs in the perl-script I'm writing on account of not having  
the time to really get around to fixing it, but that is exactly the  
procedure for generating an SELinux policy from a SMACK policy.

> I can accept that you don't see anything that can't be implemented  
> thus, but that's not the point. You've provided some really clear  
> design notes, and that's great, but it ain't the code. You said  
> that you could write a 500 line perl script that would do the whole  
> thing, and that left some people with an impression that Smack is a  
> subset of SELinux.  Well, I'm already finding myself digging out  
> from under that missunderstanding, and with people who are assuming  
> that your policy has been done, "proving" the point.

I'd love to have time to finish the script but unfortunately real  
life keeps interfering and I'm going to have to go back to lurking on  
this thread.

Cheers,
Kyle Moffett

