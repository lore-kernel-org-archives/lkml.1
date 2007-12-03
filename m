Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXLCMoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXLCMoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 07:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXLCMoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 07:44:16 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:7541 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbXLCMoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 07:44:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aMpWYxOk5G4+zI2FIWCWGyi44DqmryNUolqI43UzoOQWNXS5dhnv8lpkCn+BKkeAqG2d7874cmB0uS+3YQZVtt+6Rhze4mF7w8dDqv+AVJR/e+HdqplVkhmQoTj+5myhYIl+IILxM1td9EACEEvuSwwG0O2PEK2jKOZbWozkW+g=
Subject: Re: Kernel Development & Objective-C
From: Gilboa Davara <gilboad@gmail.com>
To: LKML Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@argo.co.il>
In-Reply-To: <1196685331.3969.20.camel@gilboa-work-dev.localdomain>
References: <474EAD18.6040408@stellatravel.co.uk>
	 <20071130143445.GA2310@csclub.uwaterloo.ca>
	 <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
	 <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de>
	 <47539030.10600@argo.co.il>
	 <1196685331.3969.20.camel@gilboa-work-dev.localdomain>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 14:44:06 +0200
Message-Id: <1196685846.3969.27.camel@gilboa-work-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-03 at 14:35 +0200, Gilboa Davara wrote:
> Intel's newest dual 10GbE NIC can easily (?) throw ~14M packets per
> second. (theoretical peak at 1514bytes/frame)
> Granted, installing such a device on a single CPU/single core machine is
> absurd - but even on an 8 core machine (2 x Xeon 53xx/54xx / AMD
> Barcelona) it can still generate ~1M packets/s per core.

Sigh... Sorry. Please ignore the broken math on my part.
Make that 1.8M frames/second per card and ~100K packets/second per core.

- Gilboa


