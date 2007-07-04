Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbXGDFCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbXGDFCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 01:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXGDFCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 01:02:34 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:41194 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXGDFCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 01:02:33 -0400
Date: Tue, 03 Jul 2007 23:01:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: pci hidden behind transparent bridge
In-reply-to: <fa.BRGomInBDtxE2DKxyvhORbn8494@ifi.uio.no>
To: Dave Jones <davej@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Ni@m" <niam.niam@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Message-id: <468B29A5.3000201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.d29hqUdPsUGcrpl+X3rShdseFNo@ifi.uio.no>
 <fa.zZbHfQyoIpHFWfUDTJdMQaanTE4@ifi.uio.no>
 <fa.BRGomInBDtxE2DKxyvhORbn8494@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Tue, Jul 03, 2007 at 06:00:14PM +0200, Michal Piotrowski wrote:
>  > Hi,
>  > 
>  > On 02/07/07, Ni@m <niam.niam@gmail.com> wrote:
>  > > Hi! I noticed such message:
>  > >
>  > > "PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#06)
>  > > (try 'pci=assign-busses')
>  > > Please report the result to linux-kernel to fix this permanently"
>  > >
>  > > on my
>  > > Linux niam 2.6.22-rc6-cfs-v18 #6 Mon Jul 2 20:19:25 EEST 2007 i686
>  > > Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel GNU/Linux
>  > >
>  > > What does it mean??
>  > 
>  > Is this a regressions?
> 
> There's about 8 gazillion of these reports that have been in bugzilla
> since the dinosaurs roamed the lands.   Just ripping the printk out
> would be my preference.
> 
> 	Dave

It seems like whoever added the message saying to report this to LKML 
hasn't responded to these reports. Any patches adding such messages in 
the future should really include details of what they expect to be done 
with the reports..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

