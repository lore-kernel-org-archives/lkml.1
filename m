Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZIJKcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZIJKcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbZIJKcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:32:00 -0400
Received: from tundra.namei.org ([65.99.196.166]:57882 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbZIJKb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:31:58 -0400
Date: Thu, 10 Sep 2009 20:31:56 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Greg KH <gregkh@suse.de>
cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, casey@schaufler-ca.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] sysfs: Add labeling support for sysfs
In-Reply-To: <20090910030121.GA32239@suse.de>
Message-ID: <alpine.LRH.2.00.0909102031430.3312@tundra.namei.org>
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov> <1252002358-6612-4-git-send-email-dpquigl@tycho.nsa.gov> <alpine.LRH.2.00.0909071147100.2538@tundra.namei.org> <1252520737.13634.833.camel@moss-pluto.epoch.ncsc.mil>
 <alpine.LRH.2.00.0909101040460.30636@tundra.namei.org> <20090910030121.GA32239@suse.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Greg KH wrote:

> On Thu, Sep 10, 2009 at 10:40:59AM +1000, James Morris wrote:
> > Thanks, all applied to
> > git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> 
> Um, wait, what about the sysfs maintainer's review?  :)

Sorry, I thought it had been reviewed.   Want me to drop it?

> 
> I also want to see Casey agree with this as well.
> 
> thanks,
> 
> greg k-h
> 

-- 
James Morris
<jmorris@namei.org>
