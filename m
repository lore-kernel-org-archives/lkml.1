Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYL1W6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYL1W6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 17:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYL1W6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 17:58:00 -0500
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:19630 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYL1W57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 17:57:59 -0500
Date: Sun, 28 Dec 2008 23:57:58 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: John Dierks <j.dierks@Verizon.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel bug in openSUSE 11.1 64 bit
In-Reply-To: <4957FA34.1050501@Verizon.net>
Message-ID: <alpine.LNX.2.00.0812282353020.10294@swampdragon.chaosbits.net>
References: <4957FA34.1050501@Verizon.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008, John Dierks wrote:

> Greetings -
> 
> I am a newbie and not familiar with the accepted way of posting bugs,
> so I am simply sending you a link to the appropriate forum discussion.
> 
> I believe we have a kernel bug in the released version of openSUSE 11.1 (64
> bit).
> 
> I have confirmed what another user (ansbar) found:  Any attempt to install 64
> bit
> 11.1 from DVD or NET media onto a D945GCLF2 platform results in a
> kernel oops soon after the version of kernel supplied with the distribution
> loads and runs.
> 
> As an aside, the platform I attempted to upgrade currently is running 11.0 (64
> bit),
> which has been running without any evidence of problems.
> 
> I hope the discussion gives you enough info to go on.  If not, feel free to
> ask questions.  Here's the link:
> 
>    http://forums.opensuse.org/install-boot-login/402136-kernel-panic-11-1-64bit.html
> 

Can you reproduce this with a standard kernel like 2.6.28 from 
http://kernel.org/ ?

Could you post a complete dump of the Oops?

(see REPORTING-BUGS in the kernel source for more useful info to post - 
 http://lxr.linux.no/linux+v2.6.28/REPORTING-BUGS)

-- 
Jesper Juhl <jj@chaosbits.net>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
