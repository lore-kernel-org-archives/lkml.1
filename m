Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZGXMO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZGXMO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 08:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZGXMOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 08:14:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40341 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752625AbZGXMOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 08:14:54 -0400
Date: Fri, 24 Jul 2009 13:15:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot panic in serial init
Message-ID: <20090724131545.309d565b@lxorguk.ukuu.org.uk>
In-Reply-To: <4A69955D.2040000@in.ibm.com>
References: <20090724171841.b128f8be.sfr@canb.auug.org.au>
	<4A69955D.2040000@in.ibm.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 16:35:01 +0530
Sachin Sant <sachinp@in.ibm.com> wrote:

> Stephen Rothwell wrote:
> > Hi Alan,
> >
> > Today's linux-next on a pSeries PowerPC machine panics during boot like
> > this:
> >   
> Similar problem on x86 as well.

Screw up on my part. New patches will get rsynced shortly.

Alan
