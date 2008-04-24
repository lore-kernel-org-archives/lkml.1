Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbYDXQUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbYDXQUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYDXQT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:19:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbYDXQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:19:56 -0400
Date: Thu, 24 Apr 2008 13:19:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Cox <alan@redhat.com>
Cc: Frank Bennett <biercenator@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       video4linux-list@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
       linux-kernel@vger.kernel.org, ivtv-devel@ivtvdriver.org
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
Message-ID: <20080424131931.4b7e513b@gaivota>
In-Reply-To: <20080424160043.GA12202@devserv.devel.redhat.com>
References: <20080420122736.20d60eff@the-village.bc.nu>
	<200804201806.33464.hverkuil@xs4all.nl>
	<480B6AD8.9090404@linuxtv.org>
	<20080423143454.0d50b209@gaivota>
	<53208a5f0804231226n3cf04ea5ja3cebb5584886183@mail.gmail.com>
	<20080424124708.3169448a@gaivota>
	<20080424160043.GA12202@devserv.devel.redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 12:00:43 -0400
Alan Cox <alan@redhat.com> wrote:

> On Thu, Apr 24, 2008 at 12:47:08PM -0300, Mauro Carvalho Chehab wrote:
> > Maybe we can just add his name in parenthesis. Would this patch description be
> > ok for you, Andrew and Alan?
> 
> I have no idea if Mr Macks did the work or minds his name being used so I 
> can form no view on the change. Obviously please remove my sign off if you
> make the change

So, I'll keep the patch as-is.

Cheers,
Mauro
