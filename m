Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYCDILW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYCDILW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYCDILM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:11:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbYCDILK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:11:10 -0500
Date: Tue, 4 Mar 2008 00:10:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
Message-Id: <20080304001026.28ade2df.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.0803040858100.5974@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803030058280.5974@sheep.housecafe.de>
	<20080303234913.f63e5fcb.akpm@linux-foundation.org>
	<alpine.DEB.1.00.0803040858100.5974@sheep.housecafe.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 09:01:13 +0100 (CET) Christian Kujau <lists@nerdbynature.de> wrote:

> On Mon, 3 Mar 2008, Andrew Morton wrote:
> > On Mon, 3 Mar 2008 01:05:53 +0100 (CET) Christian Kujau <lists@nerdbynature.de> wrote:
> >> after upgrading to 2.6.25-rc3, kern.log shows:
> >
> > From which kernel version did you upgrade?
> 
> I upgraded from 2.6.24.1. I did not try the last -rc kernels due to lack 
> of (free) time :-\
> 

OK, thanks.  Rafael, can you please add it to th list?
