Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbXE3Qn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbXE3Qn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXE3Qnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:43:51 -0400
Received: from smtp.nokia.com ([131.228.20.170]:54493 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbXE3Qnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:43:51 -0400
Message-ID: <465DA9B7.30700@yandex.ru>
Date: Wed, 30 May 2007 19:43:35 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Daniel Hazelton <dhazelton@enter.net>,
       Michael-Luke Jones <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       Mark Adler <madler@alumni.caltech.edu>, jloup@gzip.org
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression
 support - take 6)
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>	 <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com>	 <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk>	 <200705290943.11176.dhazelton@enter.net>	 <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>	 <465D7EFB.8090609@yandex.ru> <465D9C62.4070009@yandex.ru> <a781481a0705300912j4dc7776cjc50707cffd8a0cbf@mail.gmail.com>
In-Reply-To: <a781481a0705300912j4dc7776cjc50707cffd8a0cbf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 May 2007 16:43:35.0848 (UTC) FILETIME=[AAADFA80:01C7A2D9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Hi Artem,
> 
> On 5/30/07, Artem Bityutskiy <dedekind@yandex.ru> wrote:
>> Err, and important note is that it also wants this compressed data to be
>> independently uncompressable.
> 
> Hmm, okay.
> 
> But what I meant was that if jffs2's needs are "standard" enough in
> the sense that they could conceivably be required by other users too
> (and this one mentioned by you does appear to be one of those),
> then why not make such hacks (if they are necessary and suitable
> indeed, lets wait for Mark's response) part of zlib itself?

I really not sure - I vaguely remember that zlib just cannot provide this
capability. And what JFFS2 does is not always correct. But again, it was
so long time ago...

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
