Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbYHOSKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbYHOSKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 14:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYHOSJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 14:09:54 -0400
Received: from mail12.ca.com ([141.202.248.38]:30225 "EHLO mail12.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbYHOSJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 14:09:54 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
Date: Fri, 15 Aug 2008 14:09:53 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4C14@USILMS12.ca.com>
In-Reply-To: <20080815170441.GA22395@mit.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] TALPA - a threat model?  well sorta.
Thread-Index: Acj/ADfeLbbFHpnyRhCv4QwelzXzrQAASDHw
References: <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com> <20080815131820.053BF31679D@pmx1.sophos.com> <20080815170441.GA22395@mit.edu>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Theodore Tso" <tytso@mit.edu>, <douglas.leeder@sophos.com>
Cc: <alan@lxorguk.ukuu.org.uk>, <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>, <hch@infradead.org>,
       "Helge Hafting" <helge.hafting@aitel.hist.no>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       "Peter Zijlstra" <peterz@infradead.org>, <viro@ZenIV.linux.org.uk>
X-OriginalArrivalTime: 15 Aug 2008 18:09:53.0042 (UTC) FILETIME=[1D865720:01C8FF02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Theodore Tso [mailto:tytso@mit.edu]
> Sent: Friday, August 15, 2008 1:05 PM
> To: douglas.leeder@sophos.com
> Cc: Press, Jonathan; alan@lxorguk.ukuu.org.uk; andi@firstfloor.org;
Arjan van de
> Ven; hch@infradead.org; Helge Hafting; linux-kernel@vger.kernel.org;
malware-
> list@lists.printk.net; Peter Zijlstra; viro@ZenIV.linux.org.uk
> Subject: Re: [malware-list] TALPA - a threat model? well sorta.
> 
> > Not to mention removable media - it might be old hat, but
infected/malware
> > files can come in on floppies, CDs or USB flash discs careless left
on the
> > pavement outside an office.
> 
> That's not a problem given the scanning model proposed by Eric; when
> you insert removable media, it will get scanned when it is first
> accessed.

That is exactly the idea.  However, the context of this particular
thread was the following statement by Helge Hafting:

	It seems to me that this "scan on file open" business is the
wrong 
	way to do things - because it reduces performance.

	If you scan on file open, then your security sw is too late and 
	getting in the way.

 
We were just pointing out that this is not a good argument in practical
terms AGAINST scanning on open.  In fact, your reply completely
reinforces that point.


Jon Press

