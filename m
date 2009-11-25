Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbZKYSMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbZKYSMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZKYSMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:12:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53047 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753678AbZKYSMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:12:38 -0500
Date: Wed, 25 Nov 2009 18:14:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/86] pata_cmd640: document known issues
Message-ID: <20091125181444.64c49c90@lxorguk.ukuu.org.uk>
In-Reply-To: <200911251834.04189.bzolnier@gmail.com>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170436.5446.83994.sendpatchset@localhost>
	<20091125172633.7a15711b@lxorguk.ukuu.org.uk>
	<200911251834.04189.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:34:04 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wednesday 25 November 2009 06:26:33 pm Alan Cox wrote:
> > On Wed, 25 Nov 2009 18:04:36 +0100
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Subject: [PATCH] pata_cmd640: document known issues
> > > 
> > > Document known issues with the driver to aid distribution makers,
> > > users and developers in making informed decisions instead of wasting
> > > their time needlessly.
> > 
> > Umm. its a) under CONFIG_PCI, and b) says CMD640 PCI IDE...
> 
> c)
> 
>  *      This drives only the PCI version of the controller. If you have a
>  *      VLB one then we have enough docs to support it but you can write
>  *      your own code.
> 
> Then what has happened to CMD640 VLB IDE support in libata?

There is none. Nobody has complained about that either, and in fact I've
not even been able to find a board on ebay to test either driver with
VLB !
