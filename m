Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbXEUSVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbXEUSVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbXEUSU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:20:57 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:12012 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXEUSU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:20:56 -0400
Date: Mon, 21 May 2007 12:19:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Add Seagate STT20000A to DMA blacklist.
In-reply-to: <fa.xozW+S/WBbGA8Gv2z3FmAe/XymA@ifi.uio.no>
To: Dave Jones <davej@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org
Message-id: <4651E2AF.2080109@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.6aGWKqGWP2vDWJvVhFqggIUaWVk@ifi.uio.no>
 <fa.70JldrzRTUl84Jt2lSquANqNr2Q@ifi.uio.no>
 <fa.xozW+S/WBbGA8Gv2z3FmAe/XymA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Mon, May 21, 2007 at 05:15:51PM +0100, Alan Cox wrote:
>  > On Mon, 21 May 2007 10:50:42 -0400
>  > Dave Jones <davej@redhat.com> wrote:
>  > 
>  > > http://bugzilla.kernel.org/show_bug.cgi?id=1044
>  > > has been open for _four_ years with a patch available.
>  > > Here's a rediffed version of the same.
>  > 
>  > Please update libata as well when you udpate the blacklists.
> 
> Sure, point me at the table(s) ?
> 
> 	Dave
> 

ata_device_blacklist in drivers/ata/libata-core.c

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

