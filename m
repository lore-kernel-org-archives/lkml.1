Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXDWCUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXDWCUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 22:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbXDWCUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 22:20:53 -0400
Received: from mail.parknet.jp ([210.171.160.80]:4074 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbXDWCUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 22:20:52 -0400
X-AuthUser: hirofumi@parknet.jp
To: Bodo Eggert <7eggert@gmx.de>
Cc: Juergen Beisert <juergen127@kreuzholzen.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wrong free clusters count on FAT32
References: <8bAF0-3Yj-29@gated-at.bofh.it> <8bDta-8rc-31@gated-at.bofh.it>
	<8bFEr-3B4-1@gated-at.bofh.it> <8cwz8-2fE-13@gated-at.bofh.it>
	<E1Hfc7X-00010D-09@be1.lrz> <87wt04sdyb.fsf@duaron.myhome.or.jp>
	<Pine.LNX.4.58.0704222342110.3424@be1.lrz>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 23 Apr 2007 11:20:41 +0900
In-Reply-To: <Pine.LNX.4.58.0704222342110.3424@be1.lrz> (Bodo Eggert's message of "Sun\, 22 Apr 2007 23\:46\:33 +0200 \(CEST\)")
Message-ID: <87zm4zq1ae.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:

>> > - usefree is a bad name (I'd suggest recalc_free instead),
>> 
>> Is it about nofree option?
>
> Yes. I think recalc_free is way more descriptive.

Recalc is already default on current patch.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
