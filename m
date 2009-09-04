Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZIDQj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZIDQj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZIDQjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:39:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50730 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZIDQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:39:23 -0400
Date: Fri, 4 Sep 2009 17:39:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: Document the sysfs interface
Message-ID: <20090904163918.GA25419@srcf.ucam.org>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com> <20090904163520.GE1576@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904163520.GE1576@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 05:35:21PM +0100, Mark Brown wrote:
> On Fri, Sep 04, 2009 at 12:26:07PM -0400, Matthew Garrett wrote:
> 
> > The sysfs interface to the RTC class drivers is currently undocumented.
> > Add some basic documentation defining the semantics of the fields.
> 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> > +SYSFS INTERFACE
> > +---------------
> 
> Wouldn't this be better placed under Documentation/ABI?

Unsure. I'd assumed it made more sense in the existing docs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
