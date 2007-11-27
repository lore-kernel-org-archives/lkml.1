Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbXK0MjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbXK0MjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXK0Miz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:38:55 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52004 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXK0Miy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:38:54 -0500
Date: Tue, 27 Nov 2007 05:38:52 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: WARNING: at kernel/resource.c:189 __release_resource
Message-ID: <20071127123852.GB3230@parisc-linux.org>
References: <4745F77C.7040402@gmail.com> <20071126220538.1aed9c33.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126220538.1aed9c33.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 10:05:38PM -0800, Andrew Morton wrote:
> On Thu, 22 Nov 2007 22:41:16 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> > Step aside. What's the purpose of having two similar patches for one issue,
> > it then warns about the same thing twice:
> > make-sure-nobodys-leaking-resources.patch
> > releasing-resources-with-children.patch
> 
> Oh well.  It's better than having none.  Matthew, could you have think
> about something for mainline please?

I submitted it for mainline.  I was never quite sure why you only took
it into -mm.  I'll take a look at what you have in -mm these days.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
