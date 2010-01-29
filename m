Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681Ab0A2WNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0A2WNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543Ab0A2WNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:13:14 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54448 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab0A2WNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:13:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q02oK/Hz+5PYAZmg0pfQb9kTkKBJSDfJ4kU10M1QCJwpmmXa08nrWHNGK3k/wCvZNC
         1/noG5r7mYiV5iK/XsPyzX3WminN64XTZim0I17Czo5Eu/V8OsLVaGcaJ/5DWtbtkhSg
         sTrTEMFF/5zf0pDGDf0xFwRgzdgYpBFbchQYg=
Subject: Re: [PATCH v3] port ricoh_mmc to pci quirk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>, Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org
In-Reply-To: <20100129163338.GL7812@pengutronix.de>
References: <1259192401.15916.48.camel@maxim-laptop>
	 <20091125173019.74d0ddb9@fido2.homeip.net>
	 <1259279520.3991.5.camel@maxim-laptop>
	 <1259279584.3991.6.camel@maxim-laptop>
	 <20091126235551.2db699e3@fido2.homeip.net>
	 <1262964284.12577.27.camel@maxim-laptop>
	 <20100108074001.5df6c997@fido2.homeip.net>
	 <20100112154350.8fa96829.akpm@linux-foundation.org>
	 <20100113064657.GB10955@pengutronix.de>
	 <1264772255.4620.3.camel@maxim-laptop>
	 <20100129163338.GL7812@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 00:13:03 +0200
Message-ID: <1264803183.7095.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 17:33 +0100, Wolfram Sang wrote: 
> On Fri, Jan 29, 2010 at 03:37:35PM +0200, Maxim Levitsky wrote:
> > Here, updated patch with your comments addressed.
> > This is also tested with real MMC card.
> > 
> > This adds some > 80 chars lines, but I hope that is ok.
> 
> Some cosmetic issues, other than that:

I guess I introduced more spelling & grammar errors in this version that
I fixed... Anyway will try to be more careful now. English isn't my best
subject.

Best regards,
Maxim Levitsky

