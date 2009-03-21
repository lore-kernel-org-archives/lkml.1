Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZCUEjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZCUEjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 00:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZCUEja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 00:39:30 -0400
Received: from kroah.org ([198.145.64.141]:40408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750912AbZCUEj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 00:39:29 -0400
Date: Fri, 20 Mar 2009 21:36:12 -0700
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 18 (staging/comedi)
Message-ID: <20090321043612.GA482@kroah.com>
References: <20090318173830.7ea03dfb.sfr@canb.auug.org.au> <49C121C7.1040903@oracle.com> <20090318163319.GA9706@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318163319.GA9706@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 09:33:19AM -0700, Greg KH wrote:
> On Wed, Mar 18, 2009 at 09:31:03AM -0700, Randy Dunlap wrote:
> > Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20090317:
> > 
> > 
> > drivers/staging/comedi/comedi_compat32.c: In function 'compat_chaninfo':
> > drivers/staging/comedi/comedi_compat32.c:135: error: dereferencing pointer to incomplete type
> 
> <snip>
> 
> Ick, sorry about that, I'll fix it up for tomorrows -next release.

Now fixed.

thanks,

greg k-h
