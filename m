Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbZCKIdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbZCKIdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZCKIdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:33:05 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:57853 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbZCKIdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:33:04 -0400
Date: Wed, 11 Mar 2009 09:32:52 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Jean Delvare <khali@linux-fr.org>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added driver for ISL29003 ambient light sensor
Message-ID: <20090311083252.GB25824@buzzloop.caiaq.de>
References: <20090306181409.GA20135@buzzloop.caiaq.de> <20090307115449.32f0ab26@hyperion.delvare> <20090307120631.GA25276@buzzloop.caiaq.de> <20090307130818.367bcaad@hyperion.delvare> <20090309210901.GC31367@buzzloop.caiaq.de> <49B666F9.50209@cam.ac.uk> <20090310151542.GE9564@buzzloop.caiaq.de> <49B6A843.3090902@cam.ac.uk> <20090311003155.GB21160@buzzloop.caiaq.de> <20090310212826.7d8b3d4e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310212826.7d8b3d4e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 09:28:26PM -0700, Andrew Morton wrote:
> On Wed, 11 Mar 2009 01:31:55 +0100 Daniel Mack <daniel@caiaq.de> wrote:
> > > All looks fine to me.
> > > 
> > > Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> I cannot find this review which Jonathan performed.  Fumbled
> reply-to-all, or did vger break?

Jonathan replied to the posting on linux-i2c and linux-kernel wasn't in
the loop, sorry. Find his posting here:

	http://marc.info/?l=linux-i2c&m=123669064909549&w=2

> I can take care of it.
> 
> Was any thought given to the CONFIG_SYSFS=n situation?

You're right, it should depend on that. You want me so send a patch on
top of the other or one that replaces it?

Thanks,
Daniel

