Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbXISJid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbXISJid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbXISJiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:38:25 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:3360 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbXISJiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cMcU38VvVt5yvr3gysvoS0dHZSyHPsojXVjBOyDuDtN/nGhKwkfMcQ/FoqMtVwcYTe75YubkOO6K3+H0ghHaDOammkBFh6D+YUm+00xueWdJYqYAWZIyhdjubDptOo50ZgmcgifZwGcGDEBWTfleczFx2vdIO52sRxcj0w1haPI=
Message-ID: <7fac565a0709190238i78a09ab1y1f935cf3023cbe5e@mail.gmail.com>
Date: Wed, 19 Sep 2007 07:38:23 -0200
From: "Alexey Eremenko" <al4321@gmail.com>
To: linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] Consolidate host virtualization support under Virtualization menu
In-Reply-To: <46F030DD.7080201@thewybles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1189747054.7262.34.camel@localhost.localdomain>
	 <20070914091921.73007c5a.randy.dunlap@oracle.com>
	 <1189825504.7262.75.camel@localhost.localdomain>
	 <7fac565a0709150149kf55de62q92496cf74e7b0581@mail.gmail.com>
	 <1189928617.7262.98.camel@localhost.localdomain>
	 <46ED440E.3020209@goop.org>
	 <1190057480.5982.157.camel@bodhitayantram.eng.vmware.com>
	 <46EF0E0A.2000804@thewybles.com> <46EF1952.3010604@goop.org>
	 <46F030DD.7080201@thewybles.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Charles N Wyble <charles@thewybles.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> > "Host" and "guest" are better terms, I think.  Kvm is all host, since
> > guests need no modification.  lguest turns the kernel into both host and
> > guest.  Xen Linux kernels are all guest, since the Xen hypervisor is the
> > host.
> >

Yes, I also prefer terms like "Host" and "Guest". Those terms are more
correct than "Server" and "Client", which are often reffered to
TCP/UDP port listening and network connection.

-- 
-Alexey Eremenko "Technologov"
