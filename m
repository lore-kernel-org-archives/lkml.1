Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbXCTKwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbXCTKwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 06:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXCTKwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 06:52:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbXCTKwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 06:52:55 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1174376588.3392.168.camel@pmac.infradead.org> 
References: <1174376588.3392.168.camel@pmac.infradead.org>  <1173394873.3461.510.camel@pmac.infradead.org> <20070319164243.026fdbfd.akpm@linux-foundation.org> 
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [PATCH] Complain about missing system calls. 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 20 Mar 2007 10:51:33 +0000
Message-ID: <11422.1174387893@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

> > hm, did you try running this on x86_64?
> 
> I don't have any. I only tested it on PowerPC and i386. Others then
> provided more exclusions for SPARC and maybe ARM, although I'm not sure
> you have the latter yet. It's not hard to add extra exclusions.

You could always have asked to borrow my test box.

David
