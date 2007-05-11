Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbXEKI4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbXEKI4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXEKI4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:56:35 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:40014 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXEKI4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:56:34 -0400
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, jcm@redhat.com
Subject: Re: [RFC] - LXR on kernel.org ? was: Re: What tools to use?
References: <1783741195@web.de>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: 11 May 2007 10:56:33 +0200
In-Reply-To: <1783741195@web.de>
Message-ID: <873b23ivr2.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de writes:
> I like lxr pretty much.  i`m not a programmer, but i often need some
> information on "what`s the driver version of xyz in latest kernel" or
> "was this or that feature/patch already being merged" or "i have this
> line of code in kernel - how does it look in recent kernel , did it
> change " ?
> 
> over the years, i have downloaded tons of kernels for this, very much
> waste of bandwidth and time - because whenever i need to take a look,
> i have no recent kernel source around - so i need to download that big
> thing and go trough that untar orgy. having recent
> browsable/searchable and easy to find lxr`ed kernel-source online
> would be really great
> 
> i seldom find lxr for current kernels on the net, so i just wonder:
> [..]

I maintain the original LXR site at lxr.linux.no, which unfortunately
tends to lag behind quite a bit.  This is partly due to lack of time
to keep it current on my part, but also due to the fact that adding
new kernels to the version running on lxr.linux.no is a bit more time
and resource-consuming than it ought to be.  Better support for both
incremental indexing and git-based repos is forthcoming, and I hope
the situation will improve a bit with that.  I'll keep you posted.

-- 
								Arne.

