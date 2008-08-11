Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbYHKLZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbYHKLZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYHKLZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:25:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:35768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYHKLZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:25:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,341,1215414000"; 
   d="scan'208";a="428098647"
Message-ID: <48A021B2.6060205@linux.intel.com>
Date: Mon, 11 Aug 2008 13:25:38 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] Panasonic ACPI depends on INPUT
References: <20080806182828.6bfe0a16.sfr@canb.auug.org.au> <20080806172938.74b8033b.randy.dunlap@oracle.com>
In-Reply-To: <20080806172938.74b8033b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Panasonic ACPI driver needs to depend on INPUT.
> Otherwise it has build errors when CONFIG_INPUT=n:

Applied thanks.

-Andi

