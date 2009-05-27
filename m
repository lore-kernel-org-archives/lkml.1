Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbZE0PJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbZE0PJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763541AbZE0PI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:08:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598AbZE0PI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:08:57 -0400
Date: Wed, 27 May 2009 08:03:23 -0700
From: Greg KH <gregkh@suse.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gerard Lledo <gerard.lledo@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] (linux-next) Cleanups in drivers/staging/comedi
Message-ID: <20090527150323.GA31054@suse.de>
References: <1243434919-10192-1-git-send-email-gerard.lledo@gmail.com> <20090527150310.GD5982@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527150310.GD5982@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 05:03:13PM +0200, Frederic Weisbecker wrote:
> On Wed, May 27, 2009 at 05:35:17PM +0300, Gerard Lledo wrote:
> > 
> > These are 2 small patches that fix one warning and a build faulure in the
> > comedi subsystem.  Both of them were build-tested.
> 
> 
> Hi,
> 
> Don't forget to Cc linux-kernel and also Greg who is
> the staging subsystem maintainer.
> 
> (adding the missing Cc)

My scripts caught them, they are now in my ever-growing "to-apply"
queue.

thanks,

greg k-h
