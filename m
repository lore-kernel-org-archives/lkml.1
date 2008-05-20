Return-Path: <linux-kernel-owner+w=401wt.eu-S934546AbYETP4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546AbYETP4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbYETP4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:56:13 -0400
Received: from sous-sol.org ([216.99.217.87]:50831 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbYETP4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:56:12 -0400
Date: Tue, 20 May 2008 08:55:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>, Adrian Bunk <bunk@kernel.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
Subject: Re: LSM: MAINTAINERS points to no longer existing URL
Message-ID: <20080520155557.GN30402@sequoia.sous-sol.org>
References: <20080519214201.GB17716@cs181133002.pp.htv.fi> <20080519215843.GJ30402@sequoia.sous-sol.org> <1211286579.7486.75.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211286579.7486.75.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Smalley (sds@tycho.nsa.gov) wrote:
> On Mon, 2008-05-19 at 14:58 -0700, Chris Wright wrote:
> > * Adrian Bunk (bunk@kernel.org) wrote:
> > > MAINTAINERS says:
> > > 
> > > LINUX SECURITY MODULE (LSM) FRAMEWORK
> > > P:      Chris Wright
> > > M:      chrisw@sous-sol.org
> > > L:      linux-security-module@vger.kernel.org
> > > W:      http://lsm.immunix.org
> > > T:      git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
> > > S:      Supported
> > > 
> > > But http://lsm.immunix.org no longer exists.
> > 
> > Indeed, queueing this.
> 
> What about the git tree listed above?  Is it still being maintained?
> James Morris set up a security-testing git tree that was used e.g. for
> the audit conversion from direct selinux calls to using LSM hooks and
> for the security= boot parameter (i.e. for changes that went beyond just
> one LSM).

Yeah, I updated it last night to add this patch, a couple of other
trivial patches (Lindent-type) that were sent to me, and I would put
the proc ptrace one there as well, since it's touching core/smack/etc...
That needs coordination w/ any follow-on.

thanks,
-chris
