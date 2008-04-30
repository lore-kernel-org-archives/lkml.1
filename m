Return-Path: <linux-kernel-owner+w=401wt.eu-S1762051AbYD3LQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762051AbYD3LQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbYD3LP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:15:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34951 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043AbYD3LP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:15:57 -0400
Date: Wed, 30 Apr 2008 13:15:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [patch, -git] media/video/sound build fix, TEA5761/TEA5767
Message-ID: <20080430111516.GA9954@elte.hu>
References: <20080430110115.GA5633@elte.hu> <s5hiqxzwqak.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hiqxzwqak.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takashi Iwai <tiwai@suse.de> wrote:

> IMO, it's the reverse selection from sound to V4L that makes things 
> complicated.  I believe it's better to fix it as a normal dependency.
> 
> How about the patch below?

thanks, i've added it to the mix, instead of my patch.

	Ingo
