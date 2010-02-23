Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab0BWIYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:24:35 -0500
Received: from bamako.nerim.net ([62.4.17.28]:57636 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab0BWIYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:24:33 -0500
Date: Tue, 23 Feb 2010 09:24:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mike Rapoport <mike@compulab.co.il>, LKML <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH v3 2/3] i2c: convert i2c-isch to platform_device
Message-ID: <20100223092431.0fd05b5c@hyperion.delvare>
In-Reply-To: <20100223082054.GA3550@sortiz.org>
References: <4B73DAEE.5080400@compulab.co.il>
	<4B73DBB2.7020601@compulab.co.il>
	<4B7C0E5D.3070909@compulab.co.il>
	<4B812B42.2090405@compulab.co.il>
	<4B837D0C.3000708@compulab.co.il>
	<20100223091221.086ff17b@hyperion.delvare>
	<20100223082054.GA3550@sortiz.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Tue, 23 Feb 2010 09:20:55 +0100, Samuel Ortiz wrote:
> Hi Jean,
> 
> On Tue, Feb 23, 2010 at 09:12:21AM +0100, Jean Delvare wrote:
> > I can add my
> > 
> > Acked-by: Jean Delvare <khali@linux-fr.org>
> > 
> > but the patch itself would rather go through Samuel's mfd tree. The
> > different patches depend on each other so pushing them through
> > different trees would cause trouble.
> Exactly. I asked Denis to rebase them against Linus' latest because I was
> planning to merge them through my tree.
> I'll take patches 2 and 3 from this patchset.

You mean patches 1 and 2?

-- 
Jean Delvare
