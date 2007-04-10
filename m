Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbXDJOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbXDJOIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbXDJOIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:08:50 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:40023 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbXDJOIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:08:47 -0400
Date: Tue, 10 Apr 2007 10:07:19 -0400
From: Kyle McMartin <kyle@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@canonical.com
Subject: Re: [PATCH] HPA support: Revised patch
Message-ID: <20070410140719.GA18902@athena.road.mcmartin.ca>
References: <20070405141352.12fddb6e@the-village.bc.nu> <20070406163707.GA25880@srcf.ucam.org> <20070409222241.6581ecc2@the-village.bc.nu> <20070410140617.GA5255@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410140617.GA5255@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 03:06:18PM +0100, Matthew Garrett wrote:
> On Mon, Apr 09, 2007 at 10:22:41PM +0100, Alan Cox wrote:
> 
> > Please apply Tejun's fix for LBA48 data and try again. Hopefully its just
> > that which is causing the problem.
> Yes, that works absolutely fine now.

Thanks Alan, Matthew!
