Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbYHILNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbYHILNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 07:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYHILM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 07:12:59 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:54344 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYHILM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 07:12:58 -0400
Date: Sat, 9 Aug 2008 13:13:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080809111342.GA12660@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <20080731182315.GA18060@linux-mips.org> <20080809025244.GB9794@uranus.ravnborg.org> <20080809030927.GA7766@linux-sh.org> <20080809070344.GA11302@uranus.ravnborg.org> <20080809072031.GB25046@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809072031.GB25046@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 08:20:31AM +0100, Russell King wrote:
> On Sat, Aug 09, 2008 at 09:03:44AM +0200, Sam Ravnborg wrote:
> > On Sat, Aug 09, 2008 at 12:09:28PM +0900, Paul Mundt wrote:
> > > Where was this discussed? SH has the same issues obviously, but we've
> > > already settled on a scheme.
> > 
> > Looking again I realize this was only discussed on the arm kernel mailing list
> > and people involved was rmk, Harvaard and myself.
> 
> ... and with almost every other ARM person ignoring it entirely

Or they know they could trust the person dealign with it...

	Sam
