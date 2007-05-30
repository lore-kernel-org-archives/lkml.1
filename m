Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbXE3Rhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbXE3Rhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbXE3Rhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:37:43 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:38701 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126AbXE3Rhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:37:42 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <465DB1EB.5010603@am.sony.com>
Date: Wed, 30 May 2007 10:18:35 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Christoph Hellwig <hch@lst.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
References: <20070525083607.784351000@sonycom.com>	<20070525083632.677742000@sonycom.com> <20070529104948.GC29351@lst.de>	<Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>	<20070530101348.GD24586@lst.de> <1180525555.19517.268.camel@localhost.localdomain>
In-Reply-To: <1180525555.19517.268.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2007 17:18:36.0435 (UTC) FILETIME=[8EBA1E30:01C7A2DE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Wed, 2007-05-30 at 12:13 +0200, Christoph Hellwig wrote:
>> 
>> For any sane hypervisor or hardware the copy should be worth
>> than that.  Then again a sane hardware or hypervisor would support
>> SG requests..
> 
> Agreed... Sony should fix that, it's a bit ridiculous.

Yes, if only to put an end to seeing this kind of comment over 
and over again.

-Geoff

