Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYFAWnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYFAWnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 18:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYFAWnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 18:43:22 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:37704 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYFAWnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 18:43:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: =?iso-8859-1?Q?Ren=E9?= Scharfe <rene.scharfe@lsrfire.ath.cx>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       geert@linux-m68k.org
Subject: Re: [PATCH] msdos fs: remove unsettable atari option
References: <1211717062.5782.16.camel@ubuntu>
	<87ve12s849.fsf@duaron.myhome.or.jp>
	<20080601221035.GA9107@nineveh.local>
Date: Mon, 02 Jun 2008 07:43:15 +0900
In-Reply-To: <20080601221035.GA9107@nineveh.local> (Joseph Fannin's message of
	"Sun, 1 Jun 2008 18:10:37 -0400")
Message-ID: <87zlq4rd30.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Fannin <jfannin@gmail.com> writes:

> On Mon, May 26, 2008 at 12:42:29AM +0900, OGAWA Hirofumi wrote:
>> René Scharfe <rene.scharfe@lsrfire.ath.cx> writes:
>>
>> > It has been impossible to set the option 'atari' of the MSDOS filesystem
>> > for several years.  Since nobody seems to have missed it, let's remove
>> > its remains.
>> >
>> > Signed-off-by: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
>> > ---
>>
>> Looks good to me. Thanks.
>>
>> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
> Geert Uytterhoeven has a patch in his POSTPONED queue that is supposed
> to fix Atari FAT.  I can't speak to whether it works or why it's
> postponed, but it seems to compile.

I see. Although I don't know the patch, I'd like to add this part to
Geert's patch if possible. And when the patch can be posted, we can
re-add this part again.

Geert, what do you think?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
