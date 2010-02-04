Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0BDDyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:54:01 -0500
Received: from tundra.namei.org ([65.99.196.166]:45593 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab0BDDx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:53:57 -0500
Date: Thu, 4 Feb 2010 14:51:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Robin Getz <rgetz@analog.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Paul Moore <paul.moore@hp.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Etienne Basset <etienne.basset@numericable.fr>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] syslog: use defined constants instead of raw
 numbers
In-Reply-To: <20100203233713.GJ19355@outflux.net>
Message-ID: <alpine.LRH.2.00.1002041451240.26887@tundra.namei.org>
References: <20100202055354.GV19355@outflux.net> <4B67C2EA.705@schaufler-ca.com> <20100202202054.GW19355@outflux.net> <20100202212510.GG32305@us.ibm.com> <alpine.LRH.2.00.1002030859220.14592@tundra.namei.org> <20100203233713.GJ19355@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Kees Cook wrote:

> Right now the syslog "type" action are just raw numbers which makes
> the source difficult to follow.  This patch replaces the raw numbers
> with defined constants for some level of sanity.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
