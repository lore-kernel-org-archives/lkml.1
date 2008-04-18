Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYDRO4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYDRO4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYDROz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:55:59 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:39183 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbYDROz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:55:58 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-mm1: not looking good
Date: Fri, 18 Apr 2008 10:55:53 -0400
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, tglx@linutronix.de, penberg@cs.helsinki.fi,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jmorris@namei.org, sds@tycho.nsa.gov
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <200804171955.46600.paul.moore@hp.com> <20080417170407.1e68dfc8.akpm@linux-foundation.org>
In-Reply-To: <20080417170407.1e68dfc8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804181055.53281.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2008 8:04:07 pm Andrew Morton wrote:
> On Thu, 17 Apr 2008 19:55:46 -0400
>
> Paul Moore <paul.moore@hp.com> wrote:
> > For what it's worth I just looked over the changes in netnode.c and
> > nothing is jumping out at me.  The changes ran fine for me when
> > tested on the later 2.6.25-rcX kernels but I suppose that doesn't
> > mean a whole lot.
>
> Perhaps it was tested only against slub?  That config uses slab.

Yes, I believe it was testing it with slub.

-- 
paul moore
linux @ hp
