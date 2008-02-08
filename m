Return-Path: <linux-kernel-owner+w=401wt.eu-S1763604AbYBHCXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763604AbYBHCXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYBHCWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:22:51 -0500
Received: from mx.sierrawireless.com ([208.81.121.7]:25600 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbYBHCWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:22:49 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 13/45] USB: sierra: add support for Onda H600/Zte MF330datacard to USB Driver for Sierra Wireless
Date: Thu, 7 Feb 2008 18:21:55 -0800
Message-ID: <3415E2A2AB26944B9159CDB22001004D023D61F1@nestea.sierrawireless.local>
In-Reply-To: <20080207204708.GN16389@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 13/45] USB: sierra: add support for Onda H600/Zte MF330datacard to USB Driver for Sierra Wireless
Thread-Index: AchpzO/TiJ/5STk4Ttayiq/HeMu8gQALFcNQ
References: <20080207204118.202098927@mini.kroah.org> <20080207204708.GN16389@suse.de>
From: "Kevin Lloyd" <klloyd@sierrawireless.com>
To: "Greg KH" <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>, <linux-usb@vger.kernel.org>
Cc: "Justin Forbes" <jmforbes@linuxtx.org>,
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
X-OriginalArrivalTime: 08 Feb 2008 02:22:05.0614 (UTC) FILETIME=[65D2B4E0:01C869F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2.6.24-stable review patch.  If anyone has any objections, please let
us
> know.
> 
> ------------------
> From: Bruno Redondi <bruno.redondi@altarisoluzione.com>
> 
> Added support for Onda H600/Zte MF330 GPRS/UMTS/HSDPA datacard

Per our earlier discussion we probably don't want to have this one in
the Sierra driver.
