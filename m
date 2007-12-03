Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbXLCPgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbXLCPgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXLCPge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:36:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51594 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbXLCPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:36:30 -0500
Date: Mon, 3 Dec 2007 07:34:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Mark Lord <lkml@rtr.ca>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: namespace support requires network modules to say "GPL"
Message-ID: <20071203073439.7fe05875@laptopd505.fenrus.org>
In-Reply-To: <1196670255.4127.21.camel@rukbat>
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	<47515D39.9030900@rtr.ca>
	<20071201111736.297dd99a@freepuppy.rosehill>
	<20071201163035.321fd554@freepuppy.rosehill>
	<475227B1.2060802@rtr.ca>
	<1196670255.4127.21.camel@rukbat>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Dec 2007 09:24:15 +0100
Romano Giannetti <romanol@upcomillas.es> wrote:

> 
> 
> On Sat, 2007-12-01 at 22:34 -0500, Mark Lord wrote:
> > Stephen Hemminger wrote:.
> > >>
> > > I spoke too soon earlier, ndiswrapper builds and loads against
> > > current 2.6.24-rc3. Vmware and proprietary VPN software probably
> > > do not. Once again I don't give a damn, but the enterprise distro
> > > vendors certainly care.
> > ...
> > 
> > Naw, enterprise (or any other) distro vendors shouldn't have any
> > issues here, since they can just patch their kernels around any
> > issues.
> 
> Please pardon me for jumping in; 

> 
> What I think is that every time VMware or (worst) ndiswrapper breaks,

if you had read the thread... ndiswrapper doesn't break, and vmware
driver had some bugs that, once fixed, no no longer break either....


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
