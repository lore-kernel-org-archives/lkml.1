Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYIDMVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYIDMVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYIDMVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:21:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:52177 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYIDMVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:21:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="435589985"
Message-ID: <48BFD2D7.20209@linux.intel.com>
Date: Thu, 04 Sep 2008 14:21:43 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: Re: [patch 00/42] 2.6.26-stable review
References: <20080903172447.GA7731@suse.de> <20080904023905.GA1071@khazad-dum.debian.net>
In-Reply-To: <20080904023905.GA1071@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> What about this one:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f497bcc695fb828da023d74ad3c966b1e58ad21
> 
> "ACPI: Fix thermal shutdowns" ?
> 
> It should have been submitted to stable@k.o well before 2.6.26.3,

Nope because the bug it fixed was only introduced for 2.6.27-rc1.

-Andi
