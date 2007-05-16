Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbXEPAEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbXEPAEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758803AbXEPAEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:04:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359AbXEPAEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:04:04 -0400
From: Neil Brown <neilb@suse.de>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Date: Wed, 16 May 2007 10:03:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17994.19043.771733.453896@notabene.brown>
Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Software raid0 will crash the file-system, when each disk is 5TB
In-Reply-To: message from Michal Piotrowski on Wednesday May 16
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday May 16, michal.k.k.piotrowski@gmail.com wrote:
> >
> > Anybody have a clue?
> >

No...
When a raid0 array is assemble, quite a lot of message get printed
about number of zones and hash_spacing etc.  Can you collect and post
those.  Both for the failing case (2*5.5T) and the working case
(4*2.55T) is possible.

NeilBrown
