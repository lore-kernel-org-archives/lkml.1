Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbZGAIzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbZGAIzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbZGAIzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:55:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:36093 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751890AbZGAIzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:55:00 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+tfpQ//cutImHbP34KiM03VKNYU60ApbLXG+Ct3c
	1aY3HggbvC1h9O
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] block: adding __init/__exit macros to DAC960.c
Date: Wed, 1 Jul 2009 10:54:59 +0200
User-Agent: KMail/1.9.9
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906121307.29865.PeterHuewe@gmx.de> <200906230004.36995.PeterHuewe@gmx.de> <alpine.LNX.2.00.0906231048070.7457@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0906231048070.7457@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907011054.59988.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 23 Juni 2009 10:48:28 schrieb Jiri Kosina:
> On Tue, 23 Jun 2009, Peter Hüwe wrote:
> > > Trivial patch which adds the __init and __exit macros to the
> > > module_init / module_exit functions from drivers/block/DAC960.c
> > > linux version 2.6.30
> >
> > I was wondering if there is anything wrong with the patch or is it still
> > in the review phase ?
>
> I have applied it to trivial queue, thanks Peter.

Hi Jiri,

I just looked in your git tree - it still does not appear there :)
I'm sorry for bugging you with this trivial patch.

Peter
