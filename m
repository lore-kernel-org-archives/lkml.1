Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYICUcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYICUcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYICUcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:32:39 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:2184
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbYICUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:32:38 -0400
X-Trace: 165637211/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAMSRvkjDlSwG/2dsb2JhbACBZbZmgWc
X-IronPort-AV: E=Sophos;i="4.32,320,1217804400"; 
   d="scan'208";a="165637211"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: How to add the Asus R1F to asus-laptop.c?
Date: Wed, 3 Sep 2008 21:32:34 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc5-damocles; KDE/4.1.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Corentin CHARY <corentincj@iksaif.net>
References: <20080903170649.GF12476@csclub.uwaterloo.ca> <200809031859.28203.alistair@devzero.co.uk> <20080903201620.GS12474@csclub.uwaterloo.ca>
In-Reply-To: <20080903201620.GS12474@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809032132.34967.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 21:16:20 Lennart Sorensen wrote:
> On Wed, Sep 03, 2008 at 06:59:28PM +0100, Alistair John Strachan wrote:
> > Unless I'm mistaken, the current asus-laptop maintainer is Corentin
> > Chary, who I've added to CC on your behalf.
>
> Excellent.  Now where do I find such info?

MAINTAINERS, though admittedly the section is dubiously named. His name's also 
present in the copyright in the source file (drivers/misc/asus-laptop.c). It's 
also present in the source code log for this file (git log drivers/misc/asus-
laptop.c) if you discount people who have made only janitorial or API changes.

Either way, he's CC'ed, and hopefully more responsive than the sourceforge 
project :-) If not, pester Andrew Morton with the patch (and Andi Kleen, since 
it's ACPI territory).

-- 
Cheers,
Alistair.
