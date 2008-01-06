Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbYAFXXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbYAFXXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 18:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYAFXXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 18:23:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52275 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbYAFXXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 18:23:13 -0500
Date: Mon, 7 Jan 2008 00:22:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Douglas Landgraf <dougsland@gmail.com>
Cc: Gregor Jasny <jasny@vidsoft.de>, linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [v4l-dvb-maintainer] [PATCH] Re: Regression: VIDIOCGMBUF ioctl
	hangs on bttv driver (2.6.24-rc6)
Message-ID: <20080106232234.GA12783@elte.hu>
References: <20080105223338.GA18690@vidsoft.de> <20080106141548.GB18690@vidsoft.de> <68cac7520801061453w6906e510o5d53449e0b28f400@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68cac7520801061453w6906e510o5d53449e0b28f400@mail.gmail.com>
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


* Douglas Landgraf <dougsland@gmail.com> wrote:

> Hi guys,
> 
>     Gregor, we have converted bttv driver to use vidioc_ioctl2 some 
> days ago. Could you check and create your patch against v4l 
> development tree? Bttv driver does not have anymore bttv_do_ioctl().

this is about the bttv driver in 2.6.24-rc6/(rc7?) hanging. So whatever 
the devel tree does, this fix (if it's a correct fix) needs to be 
commited upstream ASAP.

	Ingo

ps. http://www.zip.com.au/~akpm/linux/patches/stuff/top-posting.txt

