Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbYHRKOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbYHRKOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYHRKOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:14:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:44118 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbYHRKOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:14:11 -0400
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
From: Peter Zijlstra <peterz@infradead.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, Theodore Tso <tytso@mit.edu>,
       douglas.leeder@sophos.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, viro@ZenIV.linux.org.uk
In-Reply-To: <48A94A55.2080309@aitel.hist.no>
References: <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com>
	 <20080815131820.053BF31679D@pmx1.sophos.com>
	 <20080815170441.GA22395@mit.edu>
	 <2629CC4E1D22A64593B02C43E855530304AE4C14@USILMS12.ca.com>
	 <48A94A55.2080309@aitel.hist.no>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 12:14:00 +0200
Message-Id: <1219054440.10800.291.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 12:09 +0200, Helge Hafting wrote:
>  
> Scanning on open should be a last resort. Scan in advance when you can.
> Of course, removable media cannot be scanned until it is inserted and 
> mounted,
> that is obvious. The scanning can start as soon as the filesystem is 
> mounted though,
> there is no reason to wait until users try to access something.
> 
> A CD inserted into a CD-server may not necessarily be needed immediately, so
> scanning in advance will help here too. The user inserting a CD in a home
> computer may start to use stuff right away, or perhaps he spends
> some time reading the docs before a complicated install. Sill room for some
> scanning in advance, which also may end up with the nice effect of 
> caching the CD.

Hmm, then there is the issue that an active scanner will avoid me from
removing the media again. Most annoysome when the machine won't promptly
give back the disk.

Imagine me browsing through a stack of unmarked dvd-rw media trying to
find the one with the right file on it, but having to wait every time
for the whole media to get scanned..

Not a nice picture.

