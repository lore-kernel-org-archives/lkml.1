Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZAZECf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZAZECf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 23:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZAZEC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 23:02:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:42776 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZAZEC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 23:02:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p4d8iUnP99COxBwF+D9aQrlgqLSKMkxUD22J2bWkKTf+Mzi8iy2K4d8TsM9wFYWYh4
         K+GpDAVz4I9o/LjeQ00YqQ1szwq5FxlP4kCWjPlLHY2bOA0T+L6zGgiZGpOLpajH75Nt
         0SbBbJBV8icN2mZ4DVL0RvAcQNyRqno4OWsP0=
Date: Mon, 26 Jan 2009 07:08:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Nick Andrew <nick@nick-andrew.net>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH 00/20] Fix misspelling of "firmware"
Message-ID: <20090126040801.GA18549@x200.localdomain>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 12:59:22PM +1100, Nick Andrew wrote:
> Fix more misspellings of "firmware" which I noticed in v2.6.29-rc2. All are
> comment changes.
> 
> Nick.
> ---
> 
> Nick Andrew (20):
>       Fix misspelling of firmware in iwl-agn.c
>       Fix misspelling of firmware in iwl3945-base.c
>       Fix misspelling of firmware in hpmain.c
>       Fix misspelling of firmware in head_64.S
>       Fix misspelling of firmware in aica.c
>       Fix misspelling of firmware in pss.c
>       Fix misspelling of firmware in disk.c
>       Fix misspelling of firmware in libata.h
>       Fix misspelling of firmware in ChangeLog.history
>       Fix misspelling of firmware in ueagle-atm.c
>       Fix misspelling of firmware in pci.c
>       Fix misspelling of firmware in cmd.c
>       Fix misspelling of firmware in ipw2200.c
>       Fix misspelling of firmware in ipw2100.c
>       Fix misspelling of firmware in tg3.c
>       Fix misspelling of firmware in sb1250-mac.c
>       Fix misspelling of firmware in thinkpad_acpi.c
>       Fix misspelling of "firmware" in ip27-smp.c
>       Fix misspelling of "firmware" in firmware.txt
>       Fix misspelling of "firmware" in ia64-kvm.txt

Please send one patch next time, nobody wants to see 20 trivial emails.
