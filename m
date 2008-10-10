Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYJJWHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYJJWHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYJJWHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:07:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbYJJWHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:07:42 -0400
Date: Fri, 10 Oct 2008 19:07:25 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
X-X-Sender: v4l@areia.chehab.org
To: Jonathan Corbet <corbet@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH, RFC] Remove videobook.tmpl
In-Reply-To: <20081010034558.6fd1fc99@tpl>
Message-ID: <alpine.LFD.2.00.0810101903150.11885@areia.chehab.org>
References: <20081010034558.6fd1fc99@tpl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Jonathan Corbet wrote:

> The V4L docbook file in the kernel seems like a trap; it might
> encourage a well-meaning developer to write for the deprecated V4L1
> API.  This patch removes it.

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>
> I have a fair amount of V4L2 documentation at
> http://lwn.net/Articles/203924/; I would be happy to put that together
> and submit it as the beginning of a replacement for videobook.tmpl.

This would be really great! Your V4L articles is the beter we currently 
have to document the internals. Having some template valuable will help us 
to keep it updated.

> It is far from complete, though, and I gather the V4L folks are planning
> to obsolete it at rather faster than the usual rate...

The plans are more to extend than to depreciate things. There are some 
demands for SoC and Embedded devices with Linux that will need more ;)

> Meanwhile, if nobody objects, I'll fold this into my docs tree.

Seems fine to me.

Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
