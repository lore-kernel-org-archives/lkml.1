Return-Path: <linux-kernel-owner+w=401wt.eu-S2992561AbXCBQGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992561AbXCBQGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992559AbXCBQGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:06:53 -0500
Received: from gw.goop.org ([64.81.55.164]:48889 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992561AbXCBQGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:06:52 -0500
Message-ID: <45E84B9A.1000003@goop.org>
Date: Fri, 02 Mar 2007 08:06:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Fixes and cleanups for earlyprintk aka boot console.
References: <45DADD15.7070809@suse.de> <20070301234645.09da8484.akpm@linux-foundation.org> <45E7F3D0.7090105@suse.de>
In-Reply-To: <45E7F3D0.7090105@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Hmm, I think this is just a chunk being lost due to the clash with the
> older version of the patch submitted as part of the xen series.
>   

But I thought the old version I had posted was well and truly dropped. 
Isn't this problematic patch the one you posted?

> Last patch queue mailed by Jeremy doesn't contain this one any more, so
> the conflict should be gone now.
>   
Yeah, this isn't absolutely required to make Xen work, so I didn't want
to confuse things by reposting it.

    J
