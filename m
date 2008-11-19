Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbYKSXLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbYKSXLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYKSXL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:11:29 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:52023 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYKSXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:11:28 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAFsrJElR9dDu/2dsb2JhbACBbdFAgnk
Date: Thu, 20 Nov 2008 00:11:24 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Bernhard Walle <bwalle@suse.de>,
       "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as executable
Message-ID: <20081119231124.GD30873@infomag.infomag.iguana.be>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de> <20081118143015.72af31d3.akpm@linux-foundation.org> <20081118233229.294270fb@kopernikus.site> <183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net> <20081119093041.1af8fd7e.akpm@linux-foundation.org> <20081119183444.56b342cb@hale.suse.de> <20081119230014.GC30873@infomag.infomag.iguana.be> <20081120000215.45071a50@kopernikus.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120000215.45071a50@kopernikus.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bernhard,

> Wasn't the conclusion that NOTIFY_OK always works and we should not
> rely on that 'allow_kdump' option?

Wasn't completely clear to me, but it would indeed be much cleaner.

Hi Tom,

What did you test exactly?

Thanks in advance,
Wim.

