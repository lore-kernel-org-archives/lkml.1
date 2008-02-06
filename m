Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbYBFSC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbYBFSC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYBFSCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:02:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbYBFSCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:02:48 -0500
Date: Wed, 6 Feb 2008 10:01:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "pHilipp Zabel" <philipp.zabel@gmail.com>
Cc: "Matt Reimer" <mreimer@vpop.net>, linux-kernel@vger.kernel.org,
       johnpol@2ka.mipt.ru, szabolcs.gyurko@tlt.hu
Subject: Re: [PATCH] DS1WM: decouple host IRQ and INTR active state
 settings.
Message-Id: <20080206100159.7d51a9e7.akpm@linux-foundation.org>
In-Reply-To: <74d0deb30802060635w4ff12f2dxdec15a26dc9722f1@mail.gmail.com>
References: <1199627174.28826.11.camel@localhost.localdomain>
	<20080107151022.82901fcc.akpm@linux-foundation.org>
	<1199751203.26310.64.camel@bilbo.vpop.net>
	<74d0deb30801080021q63df5fcfw5ff3673ec9965d08@mail.gmail.com>
	<20080205232652.895a5fbb.akpm@linux-foundation.org>
	<74d0deb30802060635w4ff12f2dxdec15a26dc9722f1@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 15:35:14 +0100 "pHilipp Zabel" <philipp.zabel@gmail.com> wrote:

> > Guys, I'm thinking that by the time we actually need this patch in the
> > mainline tree, it may well be obsolete.  So I should drop the copy I have?
> 
> I obviously think it should be applied.
> But if you prefer that I resend once it is actually needed by
> something in the tree, I'll happily do that, too.
> The PASIC2/3 mfd driver is currently waiting for something like Dmitry
> Baryshkov's clocklib patches to go in.

Well.  It's a very small patch - I'm not particularly fussed either way.
As long as you gus are sure it's safe and will be useful then I guess we
can proceed with it?
