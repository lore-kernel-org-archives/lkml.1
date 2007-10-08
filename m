Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbXJHXUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbXJHXUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbXJHXUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:20:30 -0400
Received: from mail.tmr.com ([64.65.253.246]:42369 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbXJHXU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:20:29 -0400
Message-ID: <470ABC34.3060002@tmr.com>
Date: Mon, 08 Oct 2007 19:24:36 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory	Access
 Control Kernel
References: <A508A802-AB11-4DFF-9CA8-498897CE5D03@mac.com> <63003.78064.qm@web36613.mail.mud.yahoo.com> <20071008161835.GB7106@vino.hallyn.com>
In-Reply-To: <20071008161835.GB7106@vino.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> (tongue-in-cheek)
>
> No no, everyone knows you don't build simpler things on top of more
> complicated ones, you go the other way around.  So what he was
> suggesting was that selinux be re-written on top of smack.
>   

Having gone from proposing a simpler and easier to use security system 
as an alternative to SELinux, you now propose to change the one working 
security system we have. And yes, it's hard to use, but it works. Let's 
keep this a patch, people who want adventure can have one, and people 
who have gotten Linux accepted "if SELinux is enabled" will avoid one.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

