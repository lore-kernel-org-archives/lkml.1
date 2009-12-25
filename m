Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbZLYJwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbZLYJwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 04:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZLYJwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 04:52:32 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:38978 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbZLYJwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 04:52:31 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJYZNEtR9cfx/2dsb2JhbADWGgqEKQQ
Date: Fri, 25 Dec 2009 10:52:28 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>,
       H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: linux-next: manual merge of the watchdog tree with the  tree
Message-ID: <20091225095228.GH5402@infomag.iguana.be>
References: <20091224091904.72ef2708.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091224091904.72ef2708.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stephen,

That was indeed correct. I fixed the patch.

Kind regards,
Wim.

> Hi Wim,
> 
> Today's linux-next merge of the watchdog tree got a conflict in
> drivers/watchdog/rm9k_wdt.c between commit
> de4148f3ef54b644a181ad75a6fb4b373f2b01f0 ("MIPS: eXcite: Remove
> platform") from Linus' tree and commit
> f277223000a651df741e2e3367b498049139298d ("[WATCHDOG] use resource_size
> ()") from the watchdog tree.
> 
> The former commit removes the file changed by the latter.  I just removed
> the file.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


