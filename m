Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbXIAUck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbXIAUck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 16:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXIAUca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 16:32:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbXIAUca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 16:32:30 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: eranian@hpl.hp.com
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Date: Sat, 1 Sep 2007 22:32:25 +0200
User-Agent: KMail/1.9.6
Cc: Daniel Walker <dwalker@mvista.com>,
       =?iso-8859-1?q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070828194636.GB2814@frankl.hpl.hp.com> <200709011219.49256.ak@suse.de> <20070901195142.GA9778@frankl.hpl.hp.com>
In-Reply-To: <20070901195142.GA9778@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709012232.25609.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 September 2007 21:51:42 Stephane Eranian wrote:
> Hello,
> 
> Here is a patch to fix the NMI watchdog problem on CoreDuo processor.
> I think we still need Daniel's patch to make the error path (when you
> are stuck) do the right cleanup.

Thanks.

Can that other patch please be submitted too? 

-Andi

