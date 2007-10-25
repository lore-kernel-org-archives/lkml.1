Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbXJYWn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbXJYWn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760662AbXJYWnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:43:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:32863 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760637AbXJYWnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:43:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,330,1188802800"; 
   d="scan'208";a="186367034"
Message-ID: <47211C08.2040601@intel.com>
Date: Thu, 25 Oct 2007 15:43:20 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>, David Acker <dacker@roinet.com>
CC: Bill Davidsen <davidsen@tmr.com>, Adrian Bunk <bunk@kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, saw@saw.sw.com.sg
Subject: Re: [2.6.25 patch] the planned eepro100 removal
References: <20071024162440.GN30533@stusta.de> <4720FFAA.9080709@tmr.com> <47211A67.2090201@pobox.com>
In-Reply-To: <47211A67.2090201@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2007 22:43:33.0852 (UTC) FILETIME=[793AD9C0:01C81758]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Bill Davidsen wrote:
>> Adrian Bunk wrote:
>>> This patch contains the planned removal of the eepro100 driver.
>>>
>> Are the e100 people satisfied that e100 now handles all known cases? I 
> 
> Nope.  There are still e100 work outstanding that means we cannot kill
> eepro100.

Agreed, there is still a receive unit hang in the last version that I got from
David Acker.

Auke
