Return-Path: <linux-kernel-owner+w=401wt.eu-S1765695AbXHNQts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765695AbXHNQts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764296AbXHNQtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:49:33 -0400
Received: from ns2.suse.de ([195.135.220.15]:45074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765535AbXHNQtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:49:31 -0400
Subject: Re: Documentation - How to debug ACPI Problems
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
       Alexey Starikovskiy <aystarik@gmail.com>
In-Reply-To: <200708141140.02233.lenb@kernel.org>
References: <1181140008.28514.259.camel@queen.suse.de>
	 <9a8748490706060759s5d8c43bdoc34334fcf56ee96@mail.gmail.com>
	 <1181579321.28514.304.camel@queen.suse.de>
	 <200708141140.02233.lenb@kernel.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 14 Aug 2007 18:49:26 +0200
Message-Id: <1187110166.8780.522.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 11:40 -0400, Len Brown wrote:
> > +Thomas Renninger <trenn@suse.de>, 2007
> > +Copyright (C) 2007 SUSE Linux GmbH
> 
> While it seems to be generally customary to identify the authors of Documentation
> files, it doesn't seem to be customary for them to assert a copyright.
> Is this really necessary?  My concern is that it could discourage contributors
> for user or changing the text in any way they see fit.
> 
> can anybody offer guidance on this?
> 

I am no license expert, but if you do a:
grep Copyright Documentation/ -r
you see hundreds of Copyrights clauses..., everything in kernel is under
GPL anyway and AFAIK the Copyright is just the explicit statement that
the Author implicitly has anyway...
I don't care that much whether you exactly take this one.
You still might want to take your documentation (I didn't know that you
already set up this one on your ftp account). You still might want to
merge parts of mine if it's appropriate, add a "thanks for input" or
not, at least people have something to read at the end...

Thanks,

   Thomas

