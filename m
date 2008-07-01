Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYGANG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYGANG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYGANGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:06:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40420 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbYGANGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:06:16 -0400
Subject: Re: [Linux-ATM-General] [PATCH] firmware: convert Ambassador ATM
	driver to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
Cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200807011255.m61CtW6x003038@cmf.nrl.navy.mil>
References: <200807011255.m61CtW6x003038@cmf.nrl.navy.mil>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 14:06:13 +0100
Message-Id: <1214917573.10393.391.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 08:55 -0400, Chas Williams (CONTRACTOR) wrote:
> In message <1214853492.10393.350.camel@pmac.infradead.org>,David Woodhouse writes:
> >True. But if you were to put the driver into an initrd, for example,
> 
> that is a pretty small number of people.  small enough that a physicist
> would call it zero. regardless:

Perhaps so. But in that case why do we bother with MODULE_FIRMWARE at
all? :)

-- 
dwmw2

