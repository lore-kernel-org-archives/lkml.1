Return-Path: <linux-kernel-owner+w=401wt.eu-S1764471AbYETMcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764471AbYETMcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbYETMb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:31:58 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:44308 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYETMb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:31:57 -0400
Subject: Re: LSM: MAINTAINERS points to no longer existing URL
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>
In-Reply-To: <20080519215843.GJ30402@sequoia.sous-sol.org>
References: <20080519214201.GB17716@cs181133002.pp.htv.fi>
	 <20080519215843.GJ30402@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 20 May 2008 08:29:39 -0400
Message-Id: <1211286579.7486.75.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-19 at 14:58 -0700, Chris Wright wrote:
> * Adrian Bunk (bunk@kernel.org) wrote:
> > MAINTAINERS says:
> > 
> > LINUX SECURITY MODULE (LSM) FRAMEWORK
> > P:      Chris Wright
> > M:      chrisw@sous-sol.org
> > L:      linux-security-module@vger.kernel.org
> > W:      http://lsm.immunix.org
> > T:      git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
> > S:      Supported
> > 
> > But http://lsm.immunix.org no longer exists.
> 
> Indeed, queueing this.

What about the git tree listed above?  Is it still being maintained?
James Morris set up a security-testing git tree that was used e.g. for
the audit conversion from direct selinux calls to using LSM hooks and
for the security= boot parameter (i.e. for changes that went beyond just
one LSM).

> 
> thanks,
> -chris
> --
> 
> From: Chris Wright <chrisw@sous-sol.org>
> Subject: [PATCH] LSM: remove stale web site from MAINTAINERS
> 
> Pointed out by Adrian Bunk.
> 
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  MAINTAINERS |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 915ad48..22ed22c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2548,7 +2548,6 @@ LINUX SECURITY MODULE (LSM) FRAMEWORK
>  P:	Chris Wright
>  M:	chrisw@sous-sol.org
>  L:	linux-security-module@vger.kernel.org
> -W:	http://lsm.immunix.org
>  T:	git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
>  S:	Supported
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Stephen Smalley
National Security Agency

