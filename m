Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbZAARws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbZAARws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 12:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZAARwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 12:52:38 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:46738 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZAARwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 12:52:37 -0500
Date: Thu, 01 Jan 2009 09:52:33 -0800
From: John Dierks <j.dierks@Verizon.net>
Subject: Re: kernel bug in openSUSE 11.1 64 bit
In-reply-to: <004501c96a80$85357100$0201a8c0@bui.materna.com>
To: Roland <devzero@web.de>
Cc: linux-kernel@vger.kernel.org, jj@chaosbits.net
Message-id: <495D02E1.9000506@Verizon.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <004501c96a80$85357100$0201a8c0@bui.materna.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland -

Your suggestion was the key that solved my problem.

In short, the problem does not appear to be in the openSUSE 11.1
release, but instead in the version of bios I happened to have on
my D945GCLF2 board.  Upgrading from bios version 0099 to 0122
allowed me to do a totally trouble-free upgrade from 11.0 to 11.1 (64 bit).

I have added a closing note to the forum article.

So, thank you (and you also, Jesper) for your helpful suggestions
and have a very Happy New Year!

Sincerely,
John Dierks

Roland wrote:
> Hello John,
>
> do you see any relation to this one ?
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/279186
>
> do you use the latest bios for that board?
> if not,maybe you could try if that helps ?
>
> regards
> Roland
>
>
>
>
> List:       linux-kernel
> Subject:    kernel bug in openSUSE 11.1 64 bit
> From:       John Dierks <j.dierks () Verizon ! net>
> Date:       2008-12-28 22:14:12
> Message-ID: 4957FA34.1050501 () Verizon ! net
> [Download message RAW]
>
> Greetings -
>
> I am a newbie and not familiar with the accepted way of posting bugs,
> so I am simply sending you a link to the appropriate forum discussion.
>
> I believe we have a kernel bug in the released version of openSUSE 11.1
> (64 bit).
>
> I have confirmed what another user (ansbar) found:  Any attempt to
> install 64 bit
> 11.1 from DVD or NET media onto a D945GCLF2 platform results in a
> kernel oops soon after the version of kernel supplied with the 
> distribution
> loads and runs.
>
> As an aside, the platform I attempted to upgrade currently is running
> 11.0 (64 bit),
> which has been running without any evidence of problems.
>
> I hope the discussion gives you enough info to go on.  If not, feel 
> free to
> ask questions.  Here's the link:
>
>
> http://forums.opensuse.org/install-boot-login/402136-kernel-panic-11-1-64bit.html 
>
>
> Thanks,
> John Dierks
> -- 
>
>
>
>
