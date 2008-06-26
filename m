Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbYFZSC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbYFZSC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbYFZSCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:02:10 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45143 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYFZSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:02:08 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Joe Peterson <joe@skyrush.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>
	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>
	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com>
	<877iccxnwi.fsf@devron.myhome.or.jp> <4863BD48.9000205@skyrush.com>
Date: Fri, 27 Jun 2008 02:08:08 +0900
In-Reply-To: <4863BD48.9000205@skyrush.com> (Joe Peterson's message of "Thu,
	26 Jun 2008 10:01:12 -0600")
Message-ID: <87hcbgw2dj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson <joe@skyrush.com> writes:

> I just looked at the FAT32 specification from Microsoft, and nowhere
> does it say that FAT timestamps are in local time.  It does not mention
> local time, time standards, or time zones at all.  Here it is:
>
> http://www.microsoft.com/whdc/system/platform/firmware/fatgen.mspx
>
> So there is nothing inherent in FAT's design or specification that
> requires dates and times to be in local time.  It appears it is up to
> the OS or device to convey a meaning by how the timestamps are used.
> For this reason, I do not consider it a hack or a design
> change/violation to optionally use UTC for the timestamps on a given FAT
> volume.

This is not interesting argument. That mentions MSDOS/Windows
everywhere, you just ignored it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
