Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbXEVSN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbXEVSN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759648AbXEVSNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:13:49 -0400
Received: from box.memset.com ([89.200.136.113]:49396 "EHLO box.memset.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757958AbXEVSNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:13:49 -0400
X-Greylist: delayed 1231 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 14:13:48 EDT
To: "Paa Paa" <paapaa125@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Enabling power states for Core 2 Duo
In-Reply-To: <8nGbL-4lh-25@gated-at.bofh.it>
References: <8nFz3-3gf-13@gated-at.bofh.it> <8nGbL-4lh-25@gated-at.bofh.it>
Date: Tue, 22 May 2007 18:53:13 +0100
Message-Id: <20070522175313.BD5F514C525@irishsea.home.craig-wood.com>
From: nick@craig-wood.com (Nick Craig-Wood)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paa Paa <paapaa125@hotmail.com> wrote:
>  I updated my Asus P5B Deluxe BIOS with no luck (this latest BIOS is about 1 
>  month old). Still no power states. I would be nice to know if _any_ desktop 
>  C2D mobos have these C-states? (In x86_64 system).

According to the BIOS manual there is an option called

  Intel(R) SpeedStep(tm)  Tech.

Did you enable that?

-- 
Nick Craig-Wood <nick@craig-wood.com> -- http://www.craig-wood.com/nick
