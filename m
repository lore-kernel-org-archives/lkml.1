Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbZA2W1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbZA2W1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759522AbZA2W0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:26:37 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:53224 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499AbZA2W0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:26:35 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: A B <spinflipper4@yahoo.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fat64 / exFat fs and Linux
References: <54747.12003.qm@web25801.mail.ukl.yahoo.com>
Date: Fri, 30 Jan 2009 07:26:31 +0900
In-Reply-To: <54747.12003.qm@web25801.mail.ukl.yahoo.com> (A. B.'s message of
	"Thu, 29 Jan 2009 21:52:13 +0000 (GMT)")
Message-ID: <871vul3g14.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A B <spinflipper4@yahoo.co.uk> writes:

>> OGAWA Hirofumi writes:
>>> A B <spinflipper4@yahoo.co.uk> writes:
>>> since Microsoft has now released their fat64 / exfat fs also for their
>>> 'stable' product line [1] and it seems to be the future choice for large
>>> capacity removable flash media, (...)
>>
>> I wrote the driver for read-only exFAT driver at a few months ago.
>> However, I'm not working for it actively, because I can't make time for
>> it now.
>
> Great! That sounds very promising.
> Maybe you can post it to the list or on a webpage?

Ok, I've put the patchset to,

	http://userweb.kernel.org/~hirofumi/exfat/exfat.tar.gz

exfat/series is patch order to apply, and exfat/patches/* is patches.

It would be temporary place, well, anyway, this is my lastest version.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
