Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZBJSih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZBJSih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZBJSi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:38:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZBJSi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:38:27 -0500
Date: Tue, 10 Feb 2009 16:37:49 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] use the new request_module_nowait() in
 drivers/media
Message-ID: <20090210163749.5ed916ec@pedra.chehab.org>
In-Reply-To: <200902110002.16840.rusty@rustcorp.com.au>
References: <20090208104201.6124ab6a@infradead.org>
	<20090208110052.6f3deafc@infradead.org>
	<20090209143456.1c5d7f0b@pedra.chehab.org>
	<200902110002.16840.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 00:02:15 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 10 February 2009 03:04:56 Mauro Carvalho Chehab wrote:
> > On Sun, 8 Feb 2009 11:00:52 -0800
> > Arjan van de Ven <arjan@infradead.org> wrote:
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Subject: [PATCH] use the new request_module_nowait() in drivers/media
> ...
> > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > Cheers,
> > Mauro
> 
> Thanks Mauro.  Since I have the prereq, I've taken this into my tree too.

OK.

Cheers,
Mauro
