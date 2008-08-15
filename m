Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYHOSRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYHOSRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 14:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYHOSRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 14:17:24 -0400
Received: from mail13.ca.com ([141.202.248.42]:26962 "EHLO mail13.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbYHOSRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 14:17:24 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
Date: Fri, 15 Aug 2008 14:17:23 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4C15@USILMS12.ca.com>
In-Reply-To: <alpine.DEB.1.10.0808151042500.15109@asgard.lang.hm>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] TALPA - a threat model?  well sorta.
Thread-Index: Acj+/uDtvXDWBGBSSQ+J+D3lUfmXigAA5eng
References: <1218645375.3540.71.camel@localhost.localdomain><20080813103951.1e3e5827@infradead.org><1218653864.3540.109.camel@localhost.localdomain><20080813143908.38796217@infradead.org><1218723133.3540.137.camel@localhost.localdomain><48A55574.9070508@aitel.hist.no> <1218796645.10800.242.camel@twins> <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com> <alpine.DEB.1.10.0808150924260.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C0C@USILMS12.ca.com> <alpine.DEB.1.10.0808151032121.15109@asgard.lang.hm> <2629CC4E1D22A64593B02C43E855530304AE4C12@USILMS12.ca.com> <alpine.DEB.1.10.0808151042500.15109@asgard.lang.hm>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: <david@lang.hm>
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Helge Hafting" <helge.hafting@aitel.hist.no>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <hch@infradead.org>, <andi@firstfloor.org>, <viro@ZenIV.linux.org.uk>,
       <alan@lxorguk.ukuu.org.uk>, "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 15 Aug 2008 18:17:23.0370 (UTC) FILETIME=[29F0F0A0:01C8FF03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: david@lang.hm [mailto:david@lang.hm]
> Sent: Friday, August 15, 2008 1:47 PM
> To: Press, Jonathan
> Cc: Peter Zijlstra; Helge Hafting; linux-kernel@vger.kernel.org;
malware-
> list@lists.printk.net; hch@infradead.org; andi@firstfloor.org;
> viro@ZenIV.linux.org.uk; alan@lxorguk.ukuu.org.uk; Arjan van de Ven
> Subject: RE: [malware-list] TALPA - a threat model? well sorta.
> 
> On Fri, 15 Aug 2008, Press, Jonathan wrote:
> > In addition, to generalize from the incorrect idea that the actions
of
> > root are not being defended against to the idea that the possible
> > impacts of an administrator's actions in configuring an application
> > should not be accounted for at all in our thinking doesn't make
sense to
> > me anyway.
> 
> questions had been raised about how this model could defend against
all
> the tricky things that root can do, the answer was that they are not
> trying to defend against root doing tricky things.
> 
> turning off the scanner, letting things get infected, and turning it
back
> on would fall in the same catagory as marking a file that the scanner
> marked as bad as sucessfully scanned.

Well, I agree that there are things you can't prevent, that's for sure.
But the point is to build the "threat model" and application
functionality around the idea that IF they happen, you want to be able
to plug the resulting holes as well as you can.  You can't simply close
your eyes to the possibility.


Jon Press
