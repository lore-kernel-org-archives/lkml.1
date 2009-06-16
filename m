Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZFPNPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZFPNPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 09:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZFPNO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 09:14:57 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:44279 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbZFPNO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 09:14:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TO+6CU8BaNHDLBvWSs3Z/unsEW6t4r8D5ape2mzqRgLlbbdRfWA9vsFQiOXiPZBnTH
         kO3LEYIT0wBR04Vp0Zfr6A6f7F3TRlpho5rHOT5OZjqPfiwxTjYrmGQOW6XuoiXjZwgl
         M3gGbY708+M8tplbGu2spW6i1VdJA3pNFiu/c=
Date: Tue, 16 Jun 2009 17:14:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: 2.6.29.4: softlockup at find_get_page() et al
Message-ID: <20090616131454.GA6168@x200.localdomain>
References: <20090616110051.GA4864@x200.localdomain> <20090616130833.GA27925@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616130833.GA27925@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 03:08:33PM +0200, Nick Piggin wrote:
> Thanks. Is it rebooted? It would be interesting to know what other
> CPUs are doing (and even what other tasks are doing) if it is
> still up.

It was rebooted, sorry.
