Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbXEROnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbXEROnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXEROnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:43:17 -0400
Received: from www.osadl.org ([213.239.205.134]:36711 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754443AbXEROnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:43:17 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Robert Schwebel <r.schwebel@pengutronix.de>
In-Reply-To: <464DB800.40702@genesi-usa.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
	 <464C99FF.8080404@ru.mvista.com>
	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
	 <464C9E67.2020909@ru.mvista.com>
	 <6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org>
	 <464CA222.8000407@ru.mvista.com> <464D9E7E.3090605@genesi-usa.com>
	 <464DADFC.3080802@ru.mvista.com>  <464DB800.40702@genesi-usa.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 16:48:33 +0200
Message-Id: <1179499713.12981.75.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 15:28 +0100, Matt Sealey wrote:
> >> I guess the real question is, how high resolution does a high resolution
> >> timer need to be,
> > 
> >    In the order of microseconds.
> 
> I think both the MPC52xx GPT0-7 and the SLT0-1 fulfil this fairly
> easily.

There is some basic work for MPC5200 available:

http://www.pengutronix.de/oselas/bsp/phytec/index_en.html#phyCORE-MPC5200B-tiny

	tglx


