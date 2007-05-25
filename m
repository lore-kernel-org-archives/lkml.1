Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbXEYMK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbXEYMK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbXEYMKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:10:21 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:35096 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbXEYMKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:10:20 -0400
Subject: Re: [RFC] LZO de/compression support - take 4
From: Richard Purdie <richard@openedhand.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm-cc@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Andrey Panin <pazke@donpac.ru>,
       Bret Towe <magnade@gmail.com>, Michael-Luke Jones <mlj28@cam.ac.uk>
In-Reply-To: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 May 2007 13:10:00 +0100
Message-Id: <1180095000.5864.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 17:15 +0530, Nitin Gupta wrote:
> Richard, can you please provide perf. results for this patch also?
> Also, can you please mail back latest version of your LZO patch? In
> meantime, I will try to include benchmarking support to the
> 'compress-test' module.

This version is 15% slower at decompression and about equal on
compression.

I am however still strongly of the opinion that we should just use the
version in -mm (which is my latest version).

Regards,

Richard



