Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbZCRQga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbZCRQga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbZCRQfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:35:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:55045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969AbZCRQfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:35:51 -0400
Date: Wed, 18 Mar 2009 09:33:19 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 18 (staging/comedi)
Message-ID: <20090318163319.GA9706@suse.de>
References: <20090318173830.7ea03dfb.sfr@canb.auug.org.au> <49C121C7.1040903@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C121C7.1040903@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 09:31:03AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090317:
> 
> 
> drivers/staging/comedi/comedi_compat32.c: In function 'compat_chaninfo':
> drivers/staging/comedi/comedi_compat32.c:135: error: dereferencing pointer to incomplete type

<snip>

Ick, sorry about that, I'll fix it up for tomorrows -next release.

thanks,

greg "forgot to build last night on x86-64" k-h
