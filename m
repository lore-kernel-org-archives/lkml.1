Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbZIDQwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbZIDQwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757108AbZIDQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:52:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37680 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105AbZIDQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:52:04 -0400
Date: Fri, 4 Sep 2009 17:52:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it
Subject: Re: [rtc-linux] Re: [PATCH 1/2] rtc: Document the sysfs interface
Message-ID: <20090904165206.GF1576@sirena.org.uk>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com> <20090904163520.GE1576@sirena.org.uk> <20090904163918.GA25419@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904163918.GA25419@srcf.ucam.org>
X-Cookie: YOW!!!  I am having fun!!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 05:39:18PM +0100, Matthew Garrett wrote:
> On Fri, Sep 04, 2009 at 05:35:21PM +0100, Mark Brown wrote:

> > Wouldn't this be better placed under Documentation/ABI?

> Unsure. I'd assumed it made more sense in the existing docs.

My understanding is that the sysfs ABI (and ABIs in general, I guess)
should be moving towards the more formal style of Documentation/ABI to
help manage userspace expectations - the separation of the documentation
applies to most other things in there as well.
