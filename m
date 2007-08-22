Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbXHVKQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbXHVKQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbXHVKP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:15:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:37680 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbXHVKP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YxBIs/PMP6l9DgqRYkJnFU9u28zh+MKkvINwUxM4TEu5Ss44dkyCdUdjJF/7hFVm7Awn4qVjPpWpi/8mS2RVNqccheVdYgblUuWKDviINL0trHA/XfUtORgTDsG8eRDS4FDlbaAL7ONmUoPcvYQzajpFkZggpFKDwJIKlCDjEeo=
Message-ID: <661de9470708220315l24c5313by50b9c027d0e38ba2@mail.gmail.com>
Date: Wed, 22 Aug 2007 15:45:54 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [ANNOUNCE] GCOV & LCOV Packages Released
Cc: "Subrata Modak" <subrata@linux.vnet.ibm.com>,
       ltp-announce@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <p737innzvis.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CC0216.4040200@linux.vnet.ibm.com>
	 <p737innzvis.fsf@bingen.suse.de>
X-Google-Sender-Auth: 4ffd95886f41d58e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Aug 2007 12:57:47 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Subrata Modak <subrata@linux.vnet.ibm.com> writes:
>
> > New GCOV and LCOV Packages(Patches) has been released and the same can
> > picked up from:
> > https://sourceforge.net/project/showfiles.php?group_id=3382
> > The older releases has been moved to LCOV-Archives and Gcov-Kernel-Archives.
>
> Have you considered submitting these patches for review to mainline?
>
> I always thought it was a nice feature that might be mainline
> worthy.
>
> -Andi

I second that, it would be nice to have these features in mainline instead of
maintaining them for every kernel release.

Warm Regards,
Balbir Singh
