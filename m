Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXCZMqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXCZMqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXCZMqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:46:16 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:34665 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXCZMqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:46:15 -0400
Date: Mon, 26 Mar 2007 14:43:03 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Lee Revell <rlrevell@joe-job.com>
cc: Richard Knutsson <ricknu-0@student.ltu.se>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] more scheduled OSS driver removal
In-Reply-To: <75b66ecd0703252116m5216ec8dy78528f512ae63747@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0703261437280.26461@yvahk01.tjqt.qr>
References: <20070324130602.GD752@stusta.de> <4607213B.9070005@student.ltu.se>
 <75b66ecd0703252116m5216ec8dy78528f512ae63747@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 26 2007 00:16, Lee Revell wrote:
>
> I guess he's referring to the well known "Master volume only controls
> front output" problem.  This really does need to be resolved, as many
> other ALSA drivers are effected.

I don't see that as a bug. Mine is a TerraTec DMX XFire 1024 (snd-cs46xx).

Master maps to front, Headphone to rear. PCM is the overall volume of 
digital audio (i.e. everything I can count on my fingers). Of course PCM 
is not "everything", it does not include Line Out for example. But it 
does not either on Windows (where there also is no "everything" control 
in sndvol32), so it is not a bug for me.

Jan
-- 
