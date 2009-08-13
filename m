Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbZHMCZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbZHMCZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZHMCZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:25:06 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:26189 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbZHMCZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:25:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArUEALwUg0rCTtAn/2dsb2JhbACBUtFXhBkFgic
Date: Thu, 13 Aug 2009 04:25:02 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] m68k: restore lost coldfire
	CLOCK_TICK_RATE
Message-ID: <20090813022502.GA16302@frolo.macqel>
References: <20090620201147.GA14095@frolo.macqel> <4A826453.1060609@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A826453.1060609@snapgear.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 04:42:27PM +1000, Greg Ungerer wrote:
> Hi Philippe,
>
> Philippe De Muyter wrote:
>> The good definition of CLOCK_TICK_RATE for coldfires has been lost in the
>> merge of m68k and m68knommu include files.  Restore it.  Culprit :
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ebafc17468d58bd903c886175ca84a4edc69ae1d;hp=34055b806a6334624e7e8af6eefc3aee42372a85
>> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>
> I have added this to the for-linus branch at 
> git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git.
>
> Thanks
> Greg

Thanks, Greg

Philippe
