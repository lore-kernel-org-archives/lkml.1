Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZBINdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZBINdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZBINdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:33:07 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:62803 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbZBINdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b1J/BM9UpbdcqHphv9ti64sFhlLK7IQZCFp1Rl6OZP9ULPws4+X97g4Ceou7YRDGXe
         yUVKJiFpVOj6gbA70Y9pO9Sn9VDcvKJIxx1DxF/hqfCVVUL1Vl0jcicPAVcXOIUZ6rpj
         2795xsgB8IxZjjAkgfGVegg1uyjbCnKof3J5g=
MIME-Version: 1.0
In-Reply-To: <cb7bb73a0902090345y4ef5d544ta374ee96791a80df@mail.gmail.com>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net>
	 <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>
	 <20090209094748.GC4358@atrey.karlin.mff.cuni.cz>
	 <cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com>
	 <20090209095803.GD4358@atrey.karlin.mff.cuni.cz>
	 <cb7bb73a0902090345y4ef5d544ta374ee96791a80df@mail.gmail.com>
Date: Mon, 9 Feb 2009 14:33:04 +0100
Message-ID: <cb7bb73a0902090533q3acc45b2r7d00b44aa0bdfc90@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "?ric Piel" <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org,
       Palatis Tseng <palatis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 12:45 PM, Giuseppe Bilotta
<giuseppe.bilotta@gmail.com> wrote:
> I will try this patch
> http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00164.html in
> the mean time, in case that's the patch which is in -mm.

With that patch I still get the same range of fluctuations.

-- 
Giuseppe "Oblomov" Bilotta
