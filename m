Return-Path: <linux-kernel-owner+w=401wt.eu-S1945945AbXBBPrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945945AbXBBPrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945937AbXBBPrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:47:25 -0500
Received: from 147.175.241.83.in-addr.dgcsystems.net ([83.241.175.147]:20203
	"EHLO tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1945945AbXBBPrY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:47:24 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH]ip_auto_config bug in 2.6.20-rc6
Date: Fri, 2 Feb 2007 16:47:21 +0100
Message-ID: <F6AD7E21CDF4E145A44F61F43EE6D939CBCFCB@tmnt04.transmode.se>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]ip_auto_config bug in 2.6.20-rc6
thread-index: AcdG3jzFgpeLcpBYTa2+kKerAvIEpgAAlCLA
From: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
To: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: "Netdev" <netdev@vger.kernel.org>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Thomas Bogendoerfer [mailto:tsbogend@alpha.franken.de] 
> Sent: 02 February 2007 16:18
> To: Jan Engelhardt
> Cc: Joakim Tjernlund; Netdev; Linux-Kernel
> Subject: Re: [PATCH]ip_auto_config bug in 2.6.20-rc6
> 
> On Fri, Feb 02, 2007 at 02:27:29PM +0100, Jan Engelhardt wrote:
> > >> I think this is a bug since I am not using a NFS root FS.
> > 
> > I just wonder why IP_PNP has not been obsoleted and removed 
> from the 
> > tree yet, given that initramfs is the advertised way to do so such 
> > things.
> 
> I hope this will not happen. Using BOOTP/NFS makes kernel hacking much
> easier on not yet supported machines, which offer tftp in 
> their firmware.
> 
> Thomas.

Just want to add a me too :)

 Jocke

PS.
   This is the first mail I have received in response to my postings,
please
   CC me on any replies.
