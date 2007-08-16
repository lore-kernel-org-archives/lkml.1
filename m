Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXHPSuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXHPSuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 14:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760546AbXHPSuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 14:50:40 -0400
Received: from NEUROSIS.MIT.EDU ([18.95.3.133]:49953 "EHLO neurosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932727AbXHPSui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 14:50:38 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 14:50:36 EDT
Date: Thu, 16 Aug 2007 14:45:06 -0400
From: Jim Paris <jim@jtan.com>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata_nv + ADMA + Samsung disk problem
Message-ID: <20070816184505.GA4453@jim.sh>
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <46C17634.2040504@gmail.com> <20070816160629.GL8108@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816160629.GL8108@boogie.lpds.sztaki.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabor Gombas wrote:
> On Tue, Aug 14, 2007 at 06:30:28PM +0900, Tejun Heo wrote:
> > Hmmm... That's timeout on cache flush, indicative of failing disk.
> > Please post the result of 'smartctl -a /dev/sdc'.
> 
> Ok, so something is fishy in 2.6.22 wrt. SMART.

See http://lkml.org/lkml/2007/7/8/198

-jim
