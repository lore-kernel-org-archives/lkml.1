Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbXGCRZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbXGCRZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXGCRZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:25:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbXGCRZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:25:11 -0400
Date: Tue, 3 Jul 2007 13:25:06 -0400
From: Dave Jones <davej@redhat.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Ni@m" <niam.niam@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci hidden behind transparent bridge
Message-ID: <20070703172506.GE18725@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	"Ni@m" <niam.niam@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-pci@atrey.karlin.mff.cuni.cz
References: <a9e22dff0707021209i13718d72p84160c4d3ff89e4@mail.gmail.com> <6bffcb0e0707030900k66defc1bi3ff8e70b23a050bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707030900k66defc1bi3ff8e70b23a050bf@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 06:00:14PM +0200, Michal Piotrowski wrote:
 > Hi,
 > 
 > On 02/07/07, Ni@m <niam.niam@gmail.com> wrote:
 > > Hi! I noticed such message:
 > >
 > > "PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#06)
 > > (try 'pci=assign-busses')
 > > Please report the result to linux-kernel to fix this permanently"
 > >
 > > on my
 > > Linux niam 2.6.22-rc6-cfs-v18 #6 Mon Jul 2 20:19:25 EEST 2007 i686
 > > Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel GNU/Linux
 > >
 > > What does it mean??
 > 
 > Is this a regressions?

There's about 8 gazillion of these reports that have been in bugzilla
since the dinosaurs roamed the lands.   Just ripping the printk out
would be my preference.

	Dave

-- 
http://www.codemonkey.org.uk
