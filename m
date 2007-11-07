Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbXKGQcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbXKGQcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXKGQcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:32:04 -0500
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:48216 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbXKGQcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:32:03 -0500
Message-ID: <4731E880.6010303@lougher.demon.co.uk>
Date: Wed, 07 Nov 2007 16:32:00 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANN] Squashfs 3.3 released
References: <472EFACA.1090308@lougher.demon.co.uk> <20071105115624.GJ14432@baikonur.stro.at>
In-Reply-To: <20071105115624.GJ14432@baikonur.stro.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

maximilian attems wrote:
> On Mon, Nov 05, 2007 at 11:13:14AM +0000, Phillip Lougher wrote:
>
>> The next stage after this release is to fix the one remaining blocking issue
>> (filesystem endianness), and then try to get Squashfs mainlined into the
>> Linux kernel again.
>>
> 
> that would be very cool!

Yes, it would be cool :)  Five years is a long time to maintain
something out of tree, especially recently when there's been
so many minor changes to the VFS interface between kernel releases.

> with my hat as debian kernel maintainer i'd be very relieved to see it
> mainlined. i don't know of any major distro that doesn't ship it.
> 

I don't know of any major distro that doesn't ship Squashfs either
(except arguably Slackware).  Putting my other hat on (one of the
Ubuntu kernel maintainers) I don't think Squashfs has caused
distros that many problems because it is an easy patch to apply
(it doesn't touch that many kernel files), but it is always good
to minimise the differences from the stock kernel.org kernel.

Phillip

