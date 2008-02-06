Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYBFSTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYBFSTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYBFSTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:19:25 -0500
Received: from dns1.vpop.net ([216.193.240.2]:52552 "EHLO mail.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYBFSTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:19:24 -0500
Subject: Re: [PATCH] DS1WM: decouple host IRQ and INTR active state
	settings.
From: Matt Reimer <mreimer@vpop.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org,
       johnpol@2ka.mipt.ru, szabolcs.gyurko@tlt.hu
In-Reply-To: <20080206100159.7d51a9e7.akpm@linux-foundation.org>
References: <1199627174.28826.11.camel@localhost.localdomain>
	 <20080107151022.82901fcc.akpm@linux-foundation.org>
	 <1199751203.26310.64.camel@bilbo.vpop.net>
	 <74d0deb30801080021q63df5fcfw5ff3673ec9965d08@mail.gmail.com>
	 <20080205232652.895a5fbb.akpm@linux-foundation.org>
	 <74d0deb30802060635w4ff12f2dxdec15a26dc9722f1@mail.gmail.com>
	 <20080206100159.7d51a9e7.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: VPOP Technologies, Inc
Date: Wed, 06 Feb 2008 10:19:20 -0800
Message-Id: <1202321960.5959.1.camel@bilbo.vpop.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-06 at 10:01 -0800, Andrew Morton wrote:
> On Wed, 6 Feb 2008 15:35:14 +0100 "pHilipp Zabel" <philipp.zabel@gmail.com> wrote:
> 
> > > Guys, I'm thinking that by the time we actually need this patch in the
> > > mainline tree, it may well be obsolete.  So I should drop the copy I have?
> > 
> > I obviously think it should be applied.
> > But if you prefer that I resend once it is actually needed by
> > something in the tree, I'll happily do that, too.
> > The PASIC2/3 mfd driver is currently waiting for something like Dmitry
> > Baryshkov's clocklib patches to go in.
> 
> Well.  It's a very small patch - I'm not particularly fussed either way.
> As long as you gus are sure it's safe and will be useful then I guess we
> can proceed with it?

I agree with Philipp, and think it should go in.

Matt

