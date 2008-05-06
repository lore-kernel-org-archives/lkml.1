Return-Path: <linux-kernel-owner+w=401wt.eu-S1763694AbYEFMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763694AbYEFMxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYEFMxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:53:06 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40257 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYEFMxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:53:05 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: bad pmd ffff810000207808(9090909090909090).
References: <874p9biqwj.fsf@duaron.myhome.or.jp>
	<alpine.LNX.1.10.0805061424090.16731@fbirervta.pbzchgretzou.qr>
Date: Tue, 06 May 2008 21:52:58 +0900
In-Reply-To: <alpine.LNX.1.10.0805061424090.16731@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Tue, 6 May 2008 14:35:05 +0200 (CEST)")
Message-ID: <87zlr3zj9x.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@medozas.de> writes:

> On Tuesday 2008-05-06 14:00, OGAWA Hirofumi wrote:
>
>>I've found today the following error in syslog. It seems have a strange
>>pattern. And it also happened at a month ago.
>>
>>Any idea for debuging this?
>>
>
> 90 is NOP on x86, perhaps something got rooted?

I see. I'm not sure, but I didn't notice this soon, maybe it worked as
almost usual.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
