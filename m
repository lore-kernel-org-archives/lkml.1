Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbXGXGVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbXGXGVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbXGXGV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:21:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:26070 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbXGXGVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=J/wT81kHPRAHkO1E2P0Ej3LsoWPFeQ00Q4Qfk+Lcrk49bhBmLv2sPeFBKQff5zbZzzjT5+cUEc8TWP4PdC9mnHTyx0tUxfxGgPnKaavKB7Unqox5CS9njb15pEKJvW/HK4m5jbfLlyYxEY5Vs0FRMjn7S3lZJKiinqSoC7NChVg=
Message-ID: <46A59A56.6000001@gmail.com>
Date: Tue, 24 Jul 2007 15:21:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, Takashi Iwai <tiwai@suse.de>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       Doug Chapman <doug.chapman@hp.com>, Vasily Tarasov <vtaras@openvz.org>,
       Thierry MERLE <thierry.merle@free.fr>, v4l-dvb-maintainer@linuxtv.org,
       "Dwaine P. Garden" <dwainegarden@rogers.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.23-rc1: known regressions with patches
References: <46A47940.7030801@googlemail.com>
In-Reply-To: <46A47940.7030801@googlemail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Subject         : Oops while modprobing phy fixed module
> References      : http://lkml.org/lkml/2007/7/14/63
> Last known good : ?
> Submitter       : Gabriel C <nix.or.die@googlemail.com>
> Caused-By       : Tejun Heo <htejun@gmail.com>
>                   commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
> Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
>                   Tejun Heo <htejun@gmail.com>
>                   Vitaly Bordug <vitb@kernel.crashing.org>
> Patch1          : http://lkml.org/lkml/2007/7/18/506
> Status          : patch available

Patch is in mainline.  Commit a1da4dfe35bc36c3bc9716d995c85b7983c38a76.

Thanks.

-- 
tejun
