Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbYCLXh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbYCLXh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYCLXhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:37:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbYCLXht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:37:49 -0400
Date: Wed, 12 Mar 2008 16:37:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
 Reported regressions from 2.6.24)
In-Reply-To: <Pine.LNX.4.64.0803130012470.14097@axis700.grange>
Message-ID: <alpine.LFD.1.00.0803121636030.3557@woody.linux-foundation.org>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com>
 <20080312212704.GA16836@kroah.com> <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org> <20080312223431.GA24150@kroah.com> <alpine.LFD.1.00.0803121553070.3557@woody.linux-foundation.org> <Pine.LNX.4.64.0803130012470.14097@axis700.grange>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Mar 2008, Guennadi Liakhovetski wrote:
> 
> No, no oops, no blinking LEDs.

Oh, the original report says:

  "Problem Description: Power off / reboot blink keyboard LEDs and leave 
   the system at .."

which is why I thought it might be a hidden oops.

But that must have been some unrelated and misleading red herring.

		Linus
