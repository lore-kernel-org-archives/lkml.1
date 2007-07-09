Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbXGINz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbXGINz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbXGINzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:55:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47903 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752619AbXGINzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:55:15 -0400
Message-ID: <46923E3B.70203@sgi.com>
Date: Mon, 09 Jul 2007 15:55:07 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060527)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-altix@sgi.com, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] mbcs: Remove lots of global symbols
References: <20070709145048.6de579fa@the-village.bc.nu>
In-Reply-To: <20070709145048.6de579fa@the-village.bc.nu>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> MBCS has a collection of things that searches say are not used elsewhere
> and could be static. If this is the case they should be static, if not
> then someone at SGI should rename things like "soft_list" so they don't
> pollute the global namespace with generic names...
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Hi Alan,

I don't know anything about the mbcs driver, but I bounced it by the
authors. Will get back to you asap.

Cheers,
Jes

