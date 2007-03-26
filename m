Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbXCZAus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbXCZAus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933283AbXCZAus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:50:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:49176 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933223AbXCZAui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:50:38 -0400
From: Neil Brown <neilb@suse.de>
To: "Phy Prabab" <phyprabab@gmail.com>
Date: Mon, 26 Mar 2007 10:50:31 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17927.6359.721594.133569@notabene.brown>
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net
Subject: Re: Opps in 2.6.21-rc4 nfsd
In-Reply-To: message from Phy Prabab on Friday March 23
References: <2fe399760703221224g40fc44ddof41d1fcd442612d5@mail.gmail.com>
	<20070323152913.GH752@stusta.de>
	<2fe399760703230845s4f652df0v9fd57e1aa7943e4e@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday March 23, phyprabab@gmail.com wrote:
> Adrian et al,
> 
> Under 2.6.20.2+3 I get a similar crash and more frequently.  At least
> under 2.6.21rc4 I only get this about once every two hours under heavy
> nfs testing.

That is very odd.  The code where it is crashing in the trace you
provide does not exist in 2.6.20 at all.

Do you have an Oops trace from when it crashed under 2.6.20.x ??

I'll try to have a patch for you to try on 2.6.21rc4 shortly.

What version of nfs-utils are you using?

Thanks,
NeilBrown
