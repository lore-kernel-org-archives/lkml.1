Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbZIDF33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbZIDF33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932494AbZIDF32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:29:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbZIDF32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:29:28 -0400
Date: Fri, 4 Sep 2009 01:29:29 -0400 (EDT)
From: Miroslav Rezanina <mrezanin@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Message-ID: <1906365519.636661252042169061.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4AA050A0.90609@goop.org>
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> From: "Jeremy Fitzhardinge" <jeremy@goop.org>
> To: "Miroslav Rezanina" <mrezanin@redhat.com>
> Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
> Sent: Friday, September 4, 2009 1:26:24 AM GMT +01:00 Amsterdam / Berlin / Bern / Rome / Stockholm / Vienna
> Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
>
> On 08/19/09 06:05, Miroslav Rezanina wrote:
> > when running linux as XEN guest and use boot parameter mem= to set
> memory lower then is assigned to guest, not used memory should be
> returned to hypervisor as free. This is working with kernel available
> on xen.org pages, but is not working with kernel 2.6.29. Comparing
> both kernels I found code for returning unused memory to hypervisor is
> missing. Following patch add this functionality to 2.6.29 kernel.
> >   
> 
> Are you planning on submitting a revised patch along the lines I
> suggested?
> 
> Thanks,
>     J

Hi Jeremy,
yes, I'm planning so. Unfortunatelly, I had some more important tasks to do
so I was not able to rewrite patch as you suggested.

Mirek
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Miroslav Rezanina
Software Engineer - Virtualization Team - XEN kernel

