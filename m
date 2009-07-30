Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbZG3Upx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbZG3Upx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZG3Upx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:45:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56411 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbZG3Upw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:45:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
Date: Thu, 30 Jul 2009 22:46:17 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <200907280021.26320.rjw@sisk.pl> <alpine.DEB.2.00.0907300021330.7540@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0907300021330.7540@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907302246.17742.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009, David Rientjes wrote:
> On Tue, 28 Jul 2009, Rafael J. Wysocki wrote:
> 
> > > This is fixed in mmotm with the following patches, waiting for Andrew's 
> > > push to Linus:
> > > 
> > > 	page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
> > > 	net-dccp-suppress-warning-about-large-allocations-from-dccp.patch
> > 
> > Thanks, updated.
> > 
> 
> These patches have made it to Linus' tree, so this issue is resolved.

Thanks, bug closed.

Rafael
