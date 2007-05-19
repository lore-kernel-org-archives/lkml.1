Return-Path: <linux-kernel-owner+w=401wt.eu-S1765009AbXESWhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765009AbXESWhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761725AbXESWho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:37:44 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:52092 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760203AbXESWhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:37:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H1GJWTJ9qVtKaa/IUcYvDto9/ZemrJ4zu3R8OGzsWbOMwYhXhWwccR8tZKiZXT/8cpCPCMm+xR86OFqpx7052nfo6fsekGrlTZV0lbdf8wNiDsjCBgSfSEZZ7cB4ArvBtorkcvORVajfmKWJ9UDjqCSINgMyjcbPQLBc90dh37c=
Message-ID: <6bffcb0e0705191537j61f9914y8239625b02589457@mail.gmail.com>
Date: Sun, 20 May 2007 00:37:42 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [2/5] 2.6.22-rc2: known regressions
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <464F79DA.7070808@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F6DC9.80805@googlemail.com> <464F74C4.5070404@googlemail.com>
	 <464F79DA.7070808@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On 20/05/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Michal Piotrowski wrote:
> > Memory management
>
> > Subject    : BUG: at mm/slab.c:777 __find_general_cachep()
> > References : http://lkml.org/lkml/2007/5/18/17
> > Submitter  : Jeff Garzik <jeff@garzik.org>
> > Status     : Unknown
>
> Patch available and verified: http://lkml.org/lkml/2007/5/18/19
> "avoid-zero-size-allocation-in-cache_k8_northbridges"
>
> Category is x86-64, not memory management.

Informations updated, thanks.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
