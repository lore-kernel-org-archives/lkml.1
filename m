Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbZASMum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbZASMum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbZASMud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:50:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:37489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759025AbZASMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:50:33 -0500
Date: Mon, 19 Jan 2009 04:52:42 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] async: Add some documentation.
Message-ID: <20090119045242.73ba210f@infradead.org>
In-Reply-To: <20090119132744.0beee067@gondolin>
References: <20090113174306.0f620476@gondolin>
	<20090114024952.GS8071@disturbed>
	<20090114112450.1a1af271@gondolin>
	<20090118163912.55f835a0@infradead.org>
	<20090119044045.GA6654@disturbed>
	<20090119132744.0beee067@gondolin>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 13:27:44 +0100
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> > > 
> > > I had it as that at first. But it is ugly; naming a function
> > > after its arguments is useless; it should be named after what it
> > > does instead.
> > > 
> > > I buy that "special" is not a good name. Would "local" be better?
> > > The name needs to convey that it is for a specific synchronization
> > > context....
> > 
> > Yeah, local is sounds ok - it's certainly more obvious
> > that it's a scope modifier for the synchronisation primitive.
> 
> Hm, I don't like _local too much. How about _subset, or _context, or
> _scope?

or _domain ?

and phrase stuff such that you have synchronization domains?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
