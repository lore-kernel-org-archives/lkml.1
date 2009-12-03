Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZLCJCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZLCJCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbZLCJCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:02:13 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:1204 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383AbZLCJCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:02:12 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABsNF0tR9cXB/2dsb2JhbADXIAqEJwQ
Date: Thu, 3 Dec 2009 10:02:17 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       Thomas Koeller <thomas.koeller@baslerweb.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH] eXcite: Remove platform support and drivers.
Message-ID: <20091203090217.GT3772@infomag.iguana.be>
References: <20091202153016.GA9892@linux-mips.org> <20091202153534.GA10692@linux-mips.org> <alpine.LFD.2.00.0912030709230.10116@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912030709230.10116@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

>> The platform has never been fully merged.  Remove it including MTD and
>> watchdog drivers.
>>
>> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>> ---
>> I'd like acks from the watchdog and MTD maintainers please.
>
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>

Acked-by: Wim Van Sebroeck <wim@iguana.be>

Kind regards,
Wim.

