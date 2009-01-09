Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbZAIXu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbZAIXu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZAIXuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:50:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:39183 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752510AbZAIXuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:50:12 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/c7Jl/uSfciMdfK3UXYKN7GFaxP/mbLRAYwVOJf6
	LQLFyVwzqF/RAx
Date: Sat, 10 Jan 2009 00:50:12 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-01-09-12-12 uploaded (leds)
In-Reply-To: <4967E1B3.7080707@oracle.com>
Message-ID: <Pine.LNX.4.64.0901100048380.8247@axis700.grange>
References: <200901092013.n09KDXg2011856@imap1.linux-foundation.org>
 <4967E1B3.7080707@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009, Randy Dunlap wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-01-09-12-12 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> mmotm-2009-0109-1212/drivers/leds/leds-dac124s085.c: In function 'dac124s085_probe':
> mmotm-2009-0109-1212/drivers/leds/leds-dac124s085.c:90: error: 'struct led_classdev' has no member named 'max_brightness'

Yep, Andrew, that's exactly what I meant. Don't worry, Randy, dac124s085 
has been dropped, until I find time to upgrade both patches.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
