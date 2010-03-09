Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0CIWg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:36:29 -0500
Received: from wdscspam2.wdc.com ([129.253.170.131]:22838 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab0CIWg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 17:36:26 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ATA 4 KiB sector issues.
Date: Tue, 9 Mar 2010 14:36:25 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD7A@wdscexbe01.sc.wdc.com>
In-Reply-To: <yq1r5nubze0.fsf@sermon.lab.mkp.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ATA 4 KiB sector issues.
Thread-Index: Acq+1VTje9lGIok9RuuKpD9LRuhS5QBA1VDA
References: <4B94ACE8.4060400@zytor.com> (H. Peter Anvin's message of "Sun,07 Mar 2010 23:53:12 -0800") <yq1r5nubze0.fsf@sermon.lab.mkp.net>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: "James Bottomley" <James.Bottomley@suse.de>, "Tejun Heo" <tj@kernel.org>,
       <linux-ide@vger.kernel.org>, "lkml" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Mark Lord" <kernel@teksavvy.com>,
       <tytso@mit.edu>, <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <irtiger@gmail.com>,
       "Matthew Wilcox" <matthew@wil.cx>, <aschnell@suse.de>,
       <knikanth@suse.de>, <jdelvare@suse.de>
X-OriginalArrivalTime: 09 Mar 2010 22:36:26.0263 (UTC) FILETIME=[F4197270:01CABFD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
hpa> I would very much like a reference for a platform which has 
hpa> firmware which can successfully boot from 4K-logical media.  It 
hpa> would be very useful for bootloader testing.


I am told that the Mac UEFI platform will boot from 4K logical/physical
drives.

Now I have to scrounge one of the old drives to test it.
