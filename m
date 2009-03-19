Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbZCSW3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbZCSW3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761732AbZCSW3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:29:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36793 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761761AbZCSW3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:29:21 -0400
Date: Thu, 19 Mar 2009 19:28:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 19 (media/video/au0828)
Message-ID: <20090319192846.30dceaa2@pedra.chehab.org>
In-Reply-To: <49C278D8.5010809@oracle.com>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au>
	<49C278D8.5010809@oracle.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009 09:54:48 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090318:
> 
> 
> when ADV_DEBUG=n:
> 
> 
> drivers/media/video/au0828/au0828-video.c:1438: error: 'const struct v4l2_subdev_core_ops' has no member named 'g_register'
> drivers/media/video/au0828/au0828-video.c:1453: error: 'const struct v4l2_subdev_core_ops' has no member named 's_register'

Fixed, thanks!

Cheers,
Mauro
