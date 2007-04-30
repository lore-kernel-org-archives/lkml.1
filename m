Return-Path: <linux-kernel-owner+w=401wt.eu-S1423083AbXD3Gpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423083AbXD3Gpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 02:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423084AbXD3Gpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 02:45:34 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37536 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423079AbXD3Got (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 02:44:49 -0400
Date: Sun, 29 Apr 2007 23:41:27 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [DOC] Fix wrong identifier name in
	Documentation/driver-model/devres.txt
Message-ID: <20070430064127.GA27437@kroah.com>
References: <200704260926.33826.eike-kernel@sf-tec.de> <463364CF.20801@garzik.org> <46344E45.8040701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46344E45.8040701@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 04:50:29PM +0900, Tejun Heo wrote:
> Jeff Garzik wrote:
> > Now that devres is in the kernel, I don't think I am the best person to
> > merge these sort of patches.  Certainly I can, and I know the code from
> > my original review and subsequent usage, but I think the patch is more
> > appropriate for Greg, going through normal maintainership channels.
> > 
> > IOW, I think devres is too generic to be queued via libata-dev.git.
> > 
> > Tejun, comments?
> 
> I don't have problem either way.  If it's okay with Greg, I'll queue
> future devres updates through Greg.

It's fine with me, send them on :)

thanks,

greg k-h
