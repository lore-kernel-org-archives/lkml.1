Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0CLJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:58:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:56664 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932272Ab0CLJ6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:58:23 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18pIDc/S7IpLBOfdQ+2EFKxZ+TCgel1mXL8L/uobL
	V9aqglgPVNQN0H
Date: Fri, 12 Mar 2010 10:58:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] V4L/DVB: mx1-camera: compile fix
In-Reply-To: <20100312094148.GA15123@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1003121057090.4385@axis700.grange>
References: <20100304194241.GG19843@pengutronix.de>
 <1267785924-16167-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <Pine.LNX.4.64.1003121016480.4385@axis700.grange> <20100312094148.GA15123@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010, Uwe Kleine-König wrote:

> >                       Or maybe even we shall remap those registers?
> Well, they are remapped, don't they?  Otherwise IO_ADDRESS wouldn't
> work.

Yes, they are (statically, I presume), but not in _this_ driver...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
