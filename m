Return-Path: <linux-kernel-owner+w=401wt.eu-S1764789AbXEYRkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764789AbXEYRkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbXEYRkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:40:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:10170 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbXEYRko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,580,1170662400"; 
   d="scan'208";a="249741809"
Message-ID: <46571F99.1050307@intel.com>
Date: Fri, 25 May 2007 10:40:41 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [condingstyle] Add chapter on tests
References: <20070525172509.5138.56430.stgit@localhost.localdomain> <20070525172515.5138.13652.stgit@localhost.localdomain> <46571E08.1050509@s5r6.in-berlin.de>
In-Reply-To: <46571E08.1050509@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 17:40:43.0455 (UTC) FILETIME=[D1A08CF0:01C79EF3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Auke Kok wrote:
>> +If you give your variables and pointers good names, there is never a need
>> +to compare the value stored in that variable to NULL or true/false, so
>> +omit all that and keep it short.
> 
> I agree with this in principle.  But do we have to standardize it?

yes, I think so. Not only does it remove useless fluff but it forces you to pick 
your function and variable names decently. It really doesn't hurt to mention it 
especially when you see how many drivers have copied bad style over without 
knowing better. Now we can refer them to the CodingStyle doc right away.

Auke
