Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbZHaOU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbZHaOU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZHaOUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:20:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZHaOUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:20:55 -0400
Date: Mon, 31 Aug 2009 11:20:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Message-ID: <20090831112047.35a565ef@pedra.chehab.org>
In-Reply-To: <20090831023331.3dd6f6b9@pedra.chehab.org>
References: <20090831023331.3dd6f6b9@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Em Mon, 31 Aug 2009 02:33:31 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Linus,
> 
> Please pull from:
>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

Please discard this pull request. 

This patch is not needed:

>    - usb_af9015: fix an Oops on hotplugging with 2.6.31-rc5-git3;

Hopefully, this is the last one at the series. I'll drop it and send you later a new pull request

-- 

Cheers,
Mauro
