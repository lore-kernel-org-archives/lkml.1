Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbYJRJND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbYJRJND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 05:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYJRJMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 05:12:54 -0400
Received: from sv13.net-housting.de ([80.190.144.123]:52172 "EHLO
	sv13.net-housting.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYJRJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 05:12:53 -0400
From: Tobias Frost <tobi@coldtobi.de>
To: Gaudenz Steinlin <gaudenz@debian.org>
Cc: Martin Michlmayr <tbm@cyrius.com>, Eric Sandeen <sandeen@sandeen.net>,
       linux-kernel@vger.kernel.org, debian-arm@lists.debian.org,
       xfs@oss.sgi.com
In-Reply-To: <20081017094615.GT4504@soziologie.ch>
References: <1222893502.5020.40.camel@moria>
	 <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net>
	 <20081016212500.GA27228@deprecation.cyrius.com>
	 <48F7BC9F.4080909@sandeen.net>
	 <20081017070109.GA30726@deprecation.cyrius.com>
	 <20081017094615.GT4504@soziologie.ch>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 18 Oct 2008 15:11:14 +0200
Message-Id: <1224335474.8763.1.camel@moria>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tobi@coldtobi.de
Subject: Re: XFS filesystem corruption on the arm(el) architecture
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on moria)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried xfs both on the old and new ABI.
(my first try was Jan 2008, old ABI) 
ASAIR at kernel version 2.6.18

On Fri, 2008-10-17 at 11:46 +0200, Gaudenz Steinlin wrote:
> On Fri, Oct 17, 2008 at 09:01:09AM +0200, Martin Michlmayr wrote:
> > * Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
> > > So is this a regression?  did it used to work?  If so, when? :)
> > 
> > The original report was with 2.6.18 but that was with the old ABI:
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=423562
> > I just installed a 2.6.22 kernel with EABI and I can also trigger
> > the bug.  So it's not a (recent) regression.
> 
> As far as I can remember (I only used old ABI arm) this is not a 
> regression. XFS never worked on arm for me.
> 
> If you need tests on old ABI just tell me.
> 
