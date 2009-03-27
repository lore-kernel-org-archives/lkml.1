Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZC0W3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZC0W3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZC0W3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:29:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:38458 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZC0W3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:29:31 -0400
Date: Fri, 27 Mar 2009 15:30:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
Message-ID: <20090327153044.3234722d@infradead.org>
In-Reply-To: <49CD24BC.8040303@devnull.org>
References: <cjtH6-3Ll-13@gated-at.bofh.it>
	<cjtH6-3Ll-15@gated-at.bofh.it>
	<cjtH6-3Ll-11@gated-at.bofh.it>
	<cjutt-577-11@gated-at.bofh.it>
	<cjJCb-47c-23@gated-at.bofh.it>
	<49CD24BC.8040303@devnull.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 21:10:52 +0200
Niel Lambrechts <niel.lambrechts@gmail.com> wrote:

> I'm seeing some dubious looking ATA messages even on 2.6.28.9-pae,
> although with all the 2.6.28 variants I used s2disk/resume has always
> worked. I was wondering if these "errors" perhaps play more of a role
> in 2.6.29, perhaps due to the async. changes that was mentioned?

unless you actively enabled this via a kernel command line option there
are no async changes in 2.6.29 in terms of behavior.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
