Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbZLKQia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbZLKQia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZLKQiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:38:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46156 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbZLKQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:38:23 -0500
Date: Fri, 11 Dec 2009 16:38:22 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for intel PCI thermal
	subsystem
Message-ID: <20091211163822.GA1869@srcf.ucam.org>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com> <68676e00912110828q26e511edt52546f09490c9431@mail.gmail.com> <20091211163328.GA1596@srcf.ucam.org> <68676e00912110836p278985cfv3d052e16a22916b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68676e00912110836p278985cfv3d052e16a22916b1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 05:36:59PM +0100, Luca Tettamanti wrote:
> On Fri, Dec 11, 2009 at 5:33 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >> Does it plays nice with other drivers?
> >> More specifically: is it possible to load the native driver and this
> >> one (which I presume pokes at the same chip) at the same time?
> >
> > What do you mean by native driver? This is a native driver for the chip
> > in question.
> 
> I mean the driver for the hwmon chip attached to I2C/SMB bus.

This is the hwmon chip.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
