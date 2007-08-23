Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbXHWDeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbXHWDeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbXHWDeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:34:37 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4032 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbXHWDeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:34:36 -0400
Subject: Re: [PATCH 2/2] MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070823000541.GB18739@redhat.com>
References: <1187420935.4200.16.camel@localhost>
	 <20070823000541.GB18739@redhat.com>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 20:34:27 -0700
Message-Id: <1187840067.32738.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 20:05 -0400, Dave Jones wrote:
> On Sat, Aug 18, 2007 at 12:08:54AM -0700, Joe Perches wrote:
> >  AGPGART DRIVER
> >  P:	David Airlie
> >  M:	airlied@linux.ie
> >  T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
> >  S:	Maintained
> > +F:	drivers/char/agp/
> +F: include/linux/agp*

Thanks.  What I have now:

AGPGART DRIVER
P:	David Airlie
M:	airlied@linux.ie
T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
S:	Maintained
F:	drivers/char/agp/
F:	include/linux/agp*

> CPU FREQUENCY DRIVERS
> +F: arch/x86_64/kernel/cpu/cpufreq/ too, but that's just a symlink
> right now, and the x86 unification that Thomas & Ingo are working
> on solves that problem anyway, so no biggie.

I guess that one can wait.

cheers, Joe

