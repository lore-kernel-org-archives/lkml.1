Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZFCFBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZFCFBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZFCFBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:01:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbZFCFBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:01:00 -0400
Date: Tue, 2 Jun 2009 21:46:17 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-06-02-16-11 uploaded (staging)
Message-ID: <20090603044617.GC23549@suse.de>
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org> <4A25F814.7030101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A25F814.7030101@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:12:04PM -0700, Randy Dunlap wrote:
> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-06-02-16-11 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> drivers/staging/agnx/pci.c:64:3: warning: "/*" within comment
> drivers/staging/agnx/pci.c:223:2: warning: "/*" within comment

Old issue, I'll fix it up.

> drivers/staging/android/lowmemorykiller.c:106: error: 'struct task_struct' has no member named 'oomkilladj'

Odd, I'll look into that.

thanks,

greg k-h
