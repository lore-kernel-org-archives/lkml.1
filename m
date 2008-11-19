Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYKSSeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYKSSeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYKSSeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:34:10 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:58343 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495AbYKSSeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:34:09 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFALvpI0lR9dDu/2dsb2JhbACBbdIJgnk
Date: Wed, 19 Nov 2008 19:34:03 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Bernhard Walle <bwalle@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as executable
Message-ID: <20081119183403.GA30873@infomag.infomag.iguana.be>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de> <20081118143015.72af31d3.akpm@linux-foundation.org> <20081118233229.294270fb@kopernikus.site> <183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> We have also verified that returning NOTIFY_OK from the hpwdt_pretimeout routine makes the KDUMP feature work correctly.
> 
> Bernhard pointed that out a week or so ago and we have since verified it.

I'll create the patches for the linux-2.6-watchdog trees tonight.

Kind regards,
Wim.

