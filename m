Return-Path: <linux-kernel-owner+w=401wt.eu-S1759742AbZAGQmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742AbZAGQmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759312AbZAGQlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:41:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:9389 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759214AbZAGQlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:41:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,226,1231142400"; 
   d="scan'208";a="97372426"
Message-ID: <4964DB3E.6080908@intel.com>
Date: Wed, 07 Jan 2009 09:41:34 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: Status/support for Linux HECI from Intel? (for temp/voltage monitoring)
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> The HECI interface would allow lm_sensors developers to grab the
> temperatures off the chips on the board.
> 
> From 2005(?)-2008 there was some chatter about supporting it but it never
> seemed to happen, is there any eventual planned support for supporting
> Intel's HECI interface or if the user wants to see the
> temperatures/voltages just buy a different motherboard with an ITE I/O
> controller?
> 
> I have a couple DG965WH boards and it would be nice to see the
> temperature of the chipset etc without having to reboot into the BIOS.
> 

Hi Justin,

I am not up to date on the progress in this area, but perhaps this site 
(http://www.openamt.org/) has what you are looking for?

Regards,
Dan
