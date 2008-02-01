Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbYBAGdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbYBAGdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 01:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYBAGdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 01:33:39 -0500
Received: from mga05.intel.com ([192.55.52.89]:47043 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753916AbYBAGdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 01:33:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511550562"
Message-ID: <47A2BD22.4020106@linux.intel.com>
Date: Thu, 31 Jan 2008 22:33:06 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
References: <1201829922.23523.68.camel@brick>	 <47A2A5D8.4080700@linux.intel.com> <1201843092.23523.80.camel@brick>
In-Reply-To: <1201843092.23523.80.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Something like the following (grep found me two example symbols)

to be honest, nobody reads this file with such detail; the actual UNUSED marking
is a lot more louder and people are more likely to notice those.... for all I care
we nuke the entire entry from the removals file.
