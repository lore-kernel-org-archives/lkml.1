Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZIJDET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZIJDET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZIJDES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:04:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbZIJDEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:04:15 -0400
Date: Wed, 9 Sep 2009 20:01:21 -0700
From: Greg KH <gregkh@suse.de>
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, casey@schaufler-ca.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] sysfs: Add labeling support for sysfs
Message-ID: <20090910030121.GA32239@suse.de>
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1252002358-6612-4-git-send-email-dpquigl@tycho.nsa.gov>
 <alpine.LRH.2.00.0909071147100.2538@tundra.namei.org>
 <1252520737.13634.833.camel@moss-pluto.epoch.ncsc.mil>
 <alpine.LRH.2.00.0909101040460.30636@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0909101040460.30636@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 10:40:59AM +1000, James Morris wrote:
> Thanks, all applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Um, wait, what about the sysfs maintainer's review?  :)

I also want to see Casey agree with this as well.

thanks,

greg k-h
