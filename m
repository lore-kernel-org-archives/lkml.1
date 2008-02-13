Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbYBMXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbYBMXXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbYBMXXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:23:07 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52385 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbYBMXXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:23:04 -0500
Date: Thu, 14 Feb 2008 01:22:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: harvey.harrison@gmail.com, torvalds@linux-foundation.org,
       davem@davemloft.net, tglx@linutronix.de, hpa@zytor.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported
	symbols going away
Message-ID: <20080213232248.GF12383@cs181133002.pp.htv.fi>
References: <1202941327.18204.11.camel@brick> <20080213223455.GB12383@cs181133002.pp.htv.fi> <20080213224308.GD12383@cs181133002.pp.htv.fi> <20080213145405.35fb5733.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080213145405.35fb5733.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 02:54:05PM -0800, Andrew Morton wrote:
> On Thu, 14 Feb 2008 00:43:08 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > There's simply no point in treating the removal of exports differently
> > from the many other API breaks we have in each release.
> 
> I have repeatedly and relatively patiently explained to you what the
> point is.  Simply saying that there isn't one doesn't actually make
> it go away.

Yes, we had this when you insisted on the deprecation period for 
sys_open which still brings me to explosion each time such topics come 
up and brought you _very_ near at being the first person ever in my 
killfile.

I don't get your point why bigger API changes should still be allowed 
without any advance warning while removing an export should require 
deprecation periods.

If you want to offer a stable API for external modules then please do 
it completely and with all consequences.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

