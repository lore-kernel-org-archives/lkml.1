Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYDIQ1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYDIQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbYDIQYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:24:18 -0400
Received: from fairlite.demon.co.uk ([80.176.228.186]:45119 "EHLO
	fairlite.demon.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234AbYDIQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:24:16 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 12:24:16 EDT
Subject: Re: DRM modesetting & sysfs
From: Alan Hourihane <alanh@fairlite.demon.co.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jakob Bornecrantz <wallbraker@gmail.com>, dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200804090817.02836.jbarnes@virtuousgeek.org>
References: <200804081317.43712.jbarnes@virtuousgeek.org>
	 <427ca1a20804090157t4fa1bbcei27d3bbea085aa9c3@mail.gmail.com>
	 <200804090817.02836.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 17:15:30 +0100
Message-Id: <1207757730.14588.381.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 08:17 -0700, Jesse Barnes wrote:
> On Wednesday, April 09, 2008 1:57 am Jakob Bornecrantz wrote:
> > I was going to suggest that you plug it into the hotplug_stage_two
> > function but it looks like you have already done that. Things might be
> > routed differently now then since the last time I looked at the code,
> > are you sure that stage_two is being run?
> 
> I'll have to check, I'm not sure I'm even getting interrupts...

Jesse,

Is this i915 or i945/i965 you are testing on ??

Alan.

