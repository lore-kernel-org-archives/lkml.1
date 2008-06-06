Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbYFFQft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbYFFQft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYFFQfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:35:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:16751 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYFFQfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:35:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,601,1204531200"; 
   d="scan'208";a="337061535"
Message-ID: <48496714.6030005@intel.com>
Date: Fri, 06 Jun 2008 09:34:28 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>, cpufreq@lists.linux.org.uk,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
References: <48486920.4040006@intel.com> <20080606041358.GA3457@khazad-dum.debian.net>
In-Reply-To: <20080606041358.GA3457@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2008 16:35:38.0282 (UTC) FILETIME=[5A1BF0A0:01C8C7F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Thu, 05 Jun 2008, Kok, Auke wrote:
>> This renders my Dothan to utterly poor speeds. (standard T43)
> 
> Which ThinkPad T43 model and BIOS revision?
> 
> I have a T43 2687DDU with the latest BIOS, and I have never seen
> anything like that happening.  Is it overheating or something like that?
> 

T43 2668NU3 Version: 1YET59WW (1.24 )

hardly overheating:

  Thermal zone 1 : ok, 49 C

it goes maybe up to 56C during work, but that's it.

Auke
