Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbXJRN2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbXJRN2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbXJRN2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:28:24 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55350 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbXJRN2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:28:24 -0400
Date: Thu, 18 Oct 2007 15:29:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow kconfig to accept overrides
Message-ID: <20071018132955.GB20259@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr> <20071012155708.d8abd06d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr> <47107ED2.6040509@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131338330.31913@fbirervta.pbzchgretzou.qr> <4710CF9F.6080207@s5r6.in-berlin.de> <Pine.LNX.4.64.0710131609170.3348@fbirervta.pbzchgretzou.qr> <4710F17C.8080100@oracle.com> <Pine.LNX.4.64.0710131836150.3348@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710131836150.3348@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 06:36:29PM +0200, Jan Engelhardt wrote:
> 
> On Oct 13 2007 09:25, Randy Dunlap wrote:
> > Jan Engelhardt wrote:
> >> On Oct 13 2007 16:01, Stefan Richter wrote:
> >> > > .config:176:warning: override: reassigning to symbol PREEMPT_VOLUNTARY
> >> > > .config:176:warning: override: PREEMPT_VOLUNTARY turns state choice
> >
> > .config:176:warning: override: PREEMPT_VOLUNTARY modifies state choice
> >
> > "turns" is just odd there.
> 
> Yeah, I've put in
> 	("override: %s changes choice state", sym->name);
> this morning.
Care to send me the updated patch.

Thanks,
	Sam
