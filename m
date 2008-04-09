Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYDIQgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYDIQgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYDIQgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:36:41 -0400
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:49602 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752483AbYDIQgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:36:41 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: Re: DRM modesetting & sysfs
Date: Wed, 9 Apr 2008 09:34:36 -0700
User-Agent: KMail/1.9.9
Cc: Jakob Bornecrantz <wallbraker@gmail.com>, dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200804081317.43712.jbarnes@virtuousgeek.org> <200804090817.02836.jbarnes@virtuousgeek.org> <1207757730.14588.381.camel@localhost>
In-Reply-To: <1207757730.14588.381.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804090934.37219.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 09, 2008 9:15 am Alan Hourihane wrote:
> On Wed, 2008-04-09 at 08:17 -0700, Jesse Barnes wrote:
> > On Wednesday, April 09, 2008 1:57 am Jakob Bornecrantz wrote:
> > > I was going to suggest that you plug it into the hotplug_stage_two
> > > function but it looks like you have already done that. Things might be
> > > routed differently now then since the last time I looked at the code,
> > > are you sure that stage_two is being run?
> >
> > I'll have to check, I'm not sure I'm even getting interrupts...
>
> Jesse,
>
> Is this i915 or i945/i965 you are testing on ??

I've been testing on my i915 based laptop, haven't tried my other systems 
yet...

Jesse
