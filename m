Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYIDN7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYIDN7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYIDN64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:58:56 -0400
Received: from mga06.intel.com ([134.134.136.21]:54616 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbYIDN64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:58:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="332624541"
Message-ID: <48BFE9A2.5060006@linux.intel.com>
Date: Thu, 04 Sep 2008 15:58:58 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 00/42] 2.6.26-stable review
References: <20080903172447.GA7731@suse.de> <20080904023905.GA1071@khazad-dum.debian.net> <48BFD2D7.20209@linux.intel.com> <48BFD48B.7050202@redhat.com>
In-Reply-To: <48BFD48B.7050202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz wrote:
> Andi Kleen wrote:
>> Henrique de Moraes Holschuh wrote:
>>> What about this one:
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f497bcc695fb828da023d74ad3c966b1e58ad21
>>>
>>> "ACPI: Fix thermal shutdowns" ?
>>>
>>> It should have been submitted to stable@k.o well before 2.6.26.3,
>> Nope because the bug it fixed was only introduced for 2.6.27-rc1.
> 
> No Andi, the bug _is_ in 2.6.26 tree!

I see. I wasn't aware of that. Ok the patch is needed then agreed.

-Andi
