Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbXJJXgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbXJJXgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 19:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbXJJXfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 19:35:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbXJJXfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:35:53 -0400
Message-ID: <470D61CF.3070307@redhat.com>
Date: Wed, 10 Oct 2007 19:35:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
References: <1192053794.15601.47.camel@gaivota>	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com> <d9def9db0710101624t5e0a3523p12c367dc1d414349@mail.gmail.com>
In-Reply-To: <d9def9db0710101624t5e0a3523p12c367dc1d414349@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2007 07:24 PM, Markus Rechberger wrote:
> 
> To point to more changes within the available driver which hasn't been merged
> within the last 1 1/2 years:
> * it supports non usbaudio based video devices.
> * has support for dvb-t/atsc
> * allows multiple device node access in case of analogue TV
> * has teletext/VBI support for PAL.
> * it supports modules which are now in userspace instead of
> kernelspace due disagreements with some developers for 1 1/2 years.
> * I do not agree with certain developers who do not have any experience
> with certain parts of the code for redoing it a 4th time now. My patience
> is over, which includes the company support in my back to get those
> devices supported.
> 

Do you plan on maintaining your own private driver tree for all of eternity?
