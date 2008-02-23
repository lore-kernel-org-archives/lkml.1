Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbYBWTj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbYBWTj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYBWTjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:39:21 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482AbYBWTjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:39:20 -0500
Date: Sat, 23 Feb 2008 11:38:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ian <spyro@f2s.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/6] regulator: regulator core.
Message-Id: <20080223113845.e9eb65af.akpm@linux-foundation.org>
In-Reply-To: <1203794796.17284.1.camel@wirenth>
References: <1203527351.4071.92.camel@localhost.localdomain>
	<20080223000538.e1f086e1.akpm@linux-foundation.org>
	<20080223095217.GA28356@flint.arm.linux.org.uk>
	<20080223101843.d7c001e7.akpm@linux-foundation.org>
	<1203794796.17284.1.camel@wirenth>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 19:26:36 +0000 ian <spyro@f2s.com> wrote:

> On Sat, 2008-02-23 at 10:18 -0800, Andrew Morton wrote:
> > > Renaming is not an option - "current" is an electronic term for
> > which
> > > there is no alternative.
> > 
> > amps, milliamps,
> 
> Are units of current, not current itself.

Right.  And this is an argument *in favour* of naming the sysfs files
"amps" (actually microamps), not "current".  It conveys more information.
