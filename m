Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZINPJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZINPJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZINPJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:09:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:46038 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZINPJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:09:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,383,1249282800"; 
   d="scan'208";a="550395090"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Date: Mon, 14 Sep 2009 16:08:48 +0100
Subject: RE: dca: module load should not be an error message
Thread-Topic: dca: module load should not be an error message
Thread-Index: Aco0mBFo50r3Ogs0Re2eY1DsyJ6MRQAtM/lg
Message-ID: <129600E5E5FB004392DDC3FB599660D7B55481A7@irsmsx504.ger.corp.intel.com>
References: <20090913090737.3141c842@nehalam> <4AAD2C7F.2080904@intel.com>
In-Reply-To: <4AAD2C7F.2080904@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Williams, Dan J wrote:
> Stephen Hemminger wrote:
>> The message (if it must exist) should not be an error message.
>> IMHO such messages are useless.
>> 
>> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>> 
>> ---
>> I sent patch for this previously, but it seems to have been ignored.
>> 
> 
> Sorry about that... applied now.  There are a couple other messages in
> drivers/dma/ioat/dca.c and drivers/dma/ioat/pci.c that can also be
> de-clawed.  I'll take care of those.
> 
> Thanks,
> Dan

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

Thanks,
Maciej