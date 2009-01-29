Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZA2HKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZA2HKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 02:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZA2HKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 02:10:05 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:59890 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZA2HKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 02:10:04 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: A B <spinflipper4@yahoo.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fat64 / exFat fs and Linux
References: <5272.25444.qm@web25805.mail.ukl.yahoo.com>
Date: Thu, 29 Jan 2009 16:09:57 +0900
In-Reply-To: <5272.25444.qm@web25805.mail.ukl.yahoo.com> (A. B.'s message of
	"Wed, 28 Jan 2009 11:06:25 +0000 (GMT)")
Message-ID: <874ozi4mgq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A B <spinflipper4@yahoo.co.uk> writes:

> since Microsoft has now released their fat64 / exfat fs also for their 'stable' product line [1] and it seems to be the future choice for large capacity removable flash media, it seems likely that Linux users will start seeing this fs on USB sticks, portable drives and SDXC flash cards in the near future. The status at this time seems to be that there is no driver available and the specifications are not published either. Is someone working on a driver at the moment or are there any plans? Somehow it does not seem entirely unlikely that the past nightmare of linux-unreadable NTFS disks and media prior to the present NTFS driver will repeat itself with exFAT.

I wrote the driver for read-only exFAT driver at a few months ago.
However, I'm not working for it actively, because I can't make time for
it now.

If someone want to see it, email me.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
