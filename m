Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZHZGRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZHZGRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZHZGRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:17:10 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34661 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbZHZGRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ef7x0bz75urN7ViivGD3bvEUATx1b32qxAKFG/AlIvgNulqS7yTflC++56YK+3MtSj
         bZQnQg6Qku0Xl1d+nS5LkFsawoXLSxSr9lpWcEjggBXqVWgWYS5dpE3ogU+830yIOQII
         KQe3PC2iR09Lcyp1EAwqbkvVbjkA1jFBry368=
MIME-Version: 1.0
In-Reply-To: <_yaHeGjHEzG.A.2bH.CtGlKB@chimera>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	 <_yaHeGjHEzG.A.2bH.CtGlKB@chimera>
Date: Wed, 26 Aug 2009 09:17:09 +0300
X-Google-Sender-Auth: ff684b46a2adb930
Message-ID: <84144f020908252317j202aa459u27c40eed34debd6@mail.gmail.com>
Subject: Re: [Bug #14011] Kernel paging request failed in kmem_cache_alloc
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Matthias Dahl <ml_kernel@mortal-soul.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

On Tue, Aug 25, 2009 at 11:34 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14011
> Subject         : Kernel paging request failed in kmem_cache_alloc
> Submitter       : Matthias Dahl <ml_kernel@mortal-soul.de>
> Date            : 2009-08-10 22:26 (16 days old)
> References      : http://marc.info/?l=linux-kernel&m=124993603825082&w=4

Can you reproduce the bug without the proprietary nvidia module that
seems to be loaded?

                                        Pekka
