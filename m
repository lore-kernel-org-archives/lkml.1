Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYIWA1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYIWA1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 20:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYIWA1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 20:27:06 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:46600 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYIWA1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 20:27:05 -0400
Subject: Re: [PATCH 1/2] mfd: Core support for the WM8400 AudioPlus HiFi
	CODEC and PMU
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080922183324.GA4886@localdomain>
References: <20080916094201.GA15271@rakim.wolfsonmicro.main>
	 <1221558194-15505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <20080922183324.GA4886@localdomain>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 01:27:01 +0100
Message-Id: <1222129621.6884.1.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 20:33 +0200, Samuel Ortiz wrote:
> On Tue, Sep 16, 2008 at 10:43:13AM +0100, Mark Brown wrote:
> > The WM8400 is a highly integrated audio CODEC and power management
> unit
> > optimised for use in mobile multimedia applications.  This patch adds
> > core support for the WM8400 to the MFD subsystem.
> > 
> > Both I2C and SPI access are supported by the hardware but currently only
> > I2C access is implemented.  The code is structured to allow SPI support
> > to be slotted in later.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> If it's not too late:
> Acked-by: Samuel Ortiz <sameo@openedhand.com>

It isn't :)

Thanks. Will pull & push to voltage tree.

Liam

