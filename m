Return-Path: <linux-kernel-owner+w=401wt.eu-S934471AbZIDXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934471AbZIDXXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 19:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934408AbZIDXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 19:23:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934385AbZIDXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 19:23:17 -0400
Date: Fri, 4 Sep 2009 16:23:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it
Subject: Re: [rtc-linux] Re: [PATCH 1/2] rtc: Document the sysfs interface
Message-Id: <20090904162311.a2a3f19b.akpm@linux-foundation.org>
In-Reply-To: <20090904165206.GF1576@sirena.org.uk>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com>
	<20090904163520.GE1576@sirena.org.uk>
	<20090904163918.GA25419@srcf.ucam.org>
	<20090904165206.GF1576@sirena.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 17:52:06 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Fri, Sep 04, 2009 at 05:39:18PM +0100, Matthew Garrett wrote:
> > On Fri, Sep 04, 2009 at 05:35:21PM +0100, Mark Brown wrote:
> 
> > > Wouldn't this be better placed under Documentation/ABI?
> 
> > Unsure. I'd assumed it made more sense in the existing docs.
> 
> My understanding is that the sysfs ABI (and ABIs in general, I guess)
> should be moving towards the more formal style of Documentation/ABI to
> help manage userspace expectations - the separation of the documentation
> applies to most other things in there as well.

Yes, I think you're right.

But I'm not going to pass on a documentation patch just because it's in
the wrong place ;)

