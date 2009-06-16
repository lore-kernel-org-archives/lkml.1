Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbZFPQf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbZFPQf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbZFPQft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:35:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37069 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752194AbZFPQfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:35:48 -0400
Date: Tue, 16 Jun 2009 17:36:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, greg@kroah.com, yan.i.li@intel.com
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090616173618.353901ee@lxorguk.ukuu.org.uk>
In-Reply-To: <20090616154200.GA12715@srcf.ucam.org>
References: <20090615141613.GA7876@sage.bj.intel.com>
	<20090615143446.GB19451@srcf.ucam.org>
	<20090615144748.GA25734@thyme.bj.intel.com>
	<20090616154200.GA12715@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So? If the alternative is machines that don't work until they're added 
> to a blacklist, then the correct thing to do is to do it 
> unconditionally.

I would disagree: that breaks a whole pile of other machines

Alan


