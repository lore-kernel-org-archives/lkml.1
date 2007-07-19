Return-Path: <linux-kernel-owner+w=401wt.eu-S1765135AbXGSMGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765135AbXGSMGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbXGSMG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:06:28 -0400
Received: from mail.suse.de ([195.135.220.2]:46475 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378AbXGSMG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:06:27 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [58/58] x86: remove support for the Rise CPU
Date: Thu, 19 Jul 2007 14:03:39 +0200
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719104825.GR3801@stusta.de> <20070719121340.08da9bbf@the-village.bc.nu>
In-Reply-To: <20070719121340.08da9bbf@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191403.39372.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 13:13:40 Alan Cox wrote:
> > - It's not only code, it also bloats everyone's kernel image.
> 
> Its a miniscule piece of code that is discarded on boot. Yes it might
> make the image 100 bytes longer, but have you priced a 160GB disk
> recently. I don't think 100 bytes of disk and 0 of memory really is worth
> saving for any risk at all. Its not even worth the time to apply the
> patch.

The patch is already applied.

Besides the CPU will likely boot even without special handling.

-Andi
