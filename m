Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbYBHQth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbYBHQth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760780AbYBHQs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:48:57 -0500
Received: from carmdsmtp.sierrawireless.com ([208.81.121.7]:53202 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbYBHQsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:48:55 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 13/45] USB: sierra: add support for Onda H600/ZteMF330datacard to USB Driver for Sierra Wireless
Date: Fri, 8 Feb 2008 08:50:20 -0800
Message-ID: <3415E2A2AB26944B9159CDB22001004D023D627A@nestea.sierrawireless.local>
In-Reply-To: <20080208041116.GA8122@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 13/45] USB: sierra: add support for Onda H600/ZteMF330datacard to USB Driver for Sierra Wireless
Thread-Index: AchqCJ8QYFLQEgkGQxe12U9rWCvwQwAagztw
References: <20080207204118.202098927@mini.kroah.org> <20080207204708.GN16389@suse.de> <3415E2A2AB26944B9159CDB22001004D023D61F1@nestea.sierrawireless.local> <20080208041116.GA8122@suse.de>
From: "Kevin Lloyd" <klloyd@sierrawireless.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
       <linux-usb@vger.kernel.org>, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>,
       "Bruno Redondi" <bruno.redondi@altarisoluzione.com>
X-OriginalArrivalTime: 08 Feb 2008 16:50:23.0739 (UTC) FILETIME=[B2B9B4B0:01C86A72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For now, yes, we should mirror what is going to be in the 2.6.25
kernel
> release.  I see the split happening for 2.6.26.  So I say leave this
for
> now, it adds support for users of these devices.

It's not that big a of a deal and I'm not sure how much of a pain it
would be to change it, but if the end plan is to have it in the option.c
driver and it is a one line change we might just want to get it done
now?

-Kevin
