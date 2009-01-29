Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbZA2Wmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbZA2Wmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZA2Wmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:42:37 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:49829 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZA2Wmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:42:36 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: A B <spinflipper4@yahoo.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Fat64 / exFat fs and Linux
References: <54747.12003.qm@web25801.mail.ukl.yahoo.com>
	<871vul3g14.fsf@devron.myhome.or.jp> <49822E2A.3020601@zytor.com>
Date: Fri, 30 Jan 2009 07:42:32 +0900
In-Reply-To: <49822E2A.3020601@zytor.com> (H. Peter Anvin's message of "Thu,
	29 Jan 2009 14:31:06 -0800")
Message-ID: <87wscd20pz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> OGAWA Hirofumi wrote:
>> 
>> Ok, I've put the patchset to,
>> 
>> 	http://userweb.kernel.org/~hirofumi/exfat/exfat.tar.gz
>> 
>> exfat/series is patch order to apply, and exfat/patches/* is patches.
>> 
>> It would be temporary place, well, anyway, this is my lastest version.
>> 
>
> Are there any non-sign-your-life-away specs to exFAT?

I don't know whether there is any specs. I've hacked it from the disk
image created by Vista.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
