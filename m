Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZLDKiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZLDKiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZLDKiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:38:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60194 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbZLDKiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:38:51 -0500
Date: Fri, 4 Dec 2009 10:38:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [RFC][PATCH 02/10] arm: mxc: base support for Freescale i.MX51
	processor
Message-ID: <20091204103850.GC15887@n2100.arm.linux.org.uk>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <6608c4dca645d87efce78ae0b7dbad265004f482.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6608c4dca645d87efce78ae0b7dbad265004f482.1259893118.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 04:47:02AM +0200, Amit Kucheria wrote:
> Kconfig and Makefiles to enable the i.MX51 processor separated to help ease
> the review process

This should probably come in the series after the other files have been
created.
