Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXDSO2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXDSO2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXDSO17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:27:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:2131 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbXDSO17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:27:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,428,1170662400"; 
   d="scan'208"; a="75965779:sNHT19932804"
Message-ID: <46277C36.6030301@linux.intel.com>
Date: Thu, 19 Apr 2007 07:27:02 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: Dropping CONFIG_REORDER on x86-64 for 2.6.22
References: <200704191354.52985.ak@suse.de>
In-Reply-To: <200704191354.52985.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Rationale:
> - It cannot be enabled in normal builds because all current lds
> become very slow when they have to handle thousands of sections.
> 

afaik this is only ever reported on SuSE; I've not heard it on any 
other distro...
