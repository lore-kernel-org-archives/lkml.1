Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZCKQfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZCKQfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZCKQfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:35:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbZCKQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:35:21 -0400
Date: Wed, 11 Mar 2009 09:32:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Jean Delvare <khali@linux-fr.org>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added driver for ISL29003 ambient light sensor
Message-Id: <20090311093234.7e8e5416.akpm@linux-foundation.org>
In-Reply-To: <20090311083252.GB25824@buzzloop.caiaq.de>
References: <20090306181409.GA20135@buzzloop.caiaq.de>
	<20090307115449.32f0ab26@hyperion.delvare>
	<20090307120631.GA25276@buzzloop.caiaq.de>
	<20090307130818.367bcaad@hyperion.delvare>
	<20090309210901.GC31367@buzzloop.caiaq.de>
	<49B666F9.50209@cam.ac.uk>
	<20090310151542.GE9564@buzzloop.caiaq.de>
	<49B6A843.3090902@cam.ac.uk>
	<20090311003155.GB21160@buzzloop.caiaq.de>
	<20090310212826.7d8b3d4e.akpm@linux-foundation.org>
	<20090311083252.GB25824@buzzloop.caiaq.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 09:32:52 +0100 Daniel Mack <daniel@caiaq.de> wrote:

> On Tue, Mar 10, 2009 at 09:28:26PM -0700, Andrew Morton wrote:
> > On Wed, 11 Mar 2009 01:31:55 +0100 Daniel Mack <daniel@caiaq.de> wrote:
> > > > All looks fine to me.
> > > > 
> > > > Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> > 
> > I cannot find this review which Jonathan performed.  Fumbled
> > reply-to-all, or did vger break?
> 
> Jonathan replied to the posting on linux-i2c and linux-kernel wasn't in
> the loop, sorry. Find his posting here:
> 
> 	http://marc.info/?l=linux-i2c&m=123669064909549&w=2

OK.  Please always use reply-to-all, guys.

> > I can take care of it.
> > 
> > Was any thought given to the CONFIG_SYSFS=n situation?
> 
> You're right, it should depend on that. You want me so send a patch on
> top of the other or one that replaces it?

Either way is OK by me at this time.
