Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592Ab0AQXSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0AQXSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 18:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336Ab0AQXSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 18:18:00 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:37550 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab0AQXR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 18:17:59 -0500
Date: Sun, 17 Jan 2010 15:17:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 14 (drm header files)
Message-Id: <20100117151718.f88c5f21.randy.dunlap@oracle.com>
In-Reply-To: <20100114172047.406ebda8.sfr@canb.auug.org.au>
References: <20100114172047.406ebda8.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B539AA2.004B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 17:20:47 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100113:


Is anything being done about these?
or does anything need to be done?


usr/include/drm/drm_mode.h:84: found __[us]{8,16,32,64} type without #include <linux/types.h>
usr/include/drm/i915_drm.h:119: found __[us]{8,16,32,64} type without #include <linux/types.h>
usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>


Thanks,
---
~Randy
