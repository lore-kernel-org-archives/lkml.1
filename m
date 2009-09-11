Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbZIKE1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbZIKE1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 00:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZIKE1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 00:27:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:38510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZIKE1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 00:27:01 -0400
Date: Thu, 10 Sep 2009 21:25:01 -0700
From: Greg KH <gregkh@suse.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] sysfs: Add labeling support for sysfs
Message-ID: <20090911042501.GA14503@suse.de>
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1252002358-6612-4-git-send-email-dpquigl@tycho.nsa.gov>
 <alpine.LRH.2.00.0909071147100.2538@tundra.namei.org>
 <1252520737.13634.833.camel@moss-pluto.epoch.ncsc.mil>
 <alpine.LRH.2.00.0909101040460.30636@tundra.namei.org>
 <20090910030121.GA32239@suse.de>
 <4AA9CF46.1050908@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA9CF46.1050908@schaufler-ca.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 09:17:10PM -0700, Casey Schaufler wrote:
> Greg KH wrote:
> > On Thu, Sep 10, 2009 at 10:40:59AM +1000, James Morris wrote:
> >   
> >> Thanks, all applied to
> >> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> >>     
> >
> > Um, wait, what about the sysfs maintainer's review?  :)
> >
> > I also want to see Casey agree with this as well.
> >   
> 
> Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> As I said before, I still want to see general xattr support,
> but I suppose that can wait for a later date. I've held this
> up long enough.

Ok, I have no objections to it either.  James, please add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patches.

thanks,

greg k-h
