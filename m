Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYJWBBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYJWBBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYJWBBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:01:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:58747 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbYJWBBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=gNmhFD3MNrDWsPvfpbfmjvYYkK1YJInxHvzbrvqsVkfKyFHNt9fGamcHsejYMk8pxH
         CWf6lvPrVu8h3Mc0zlUCFrx9s2aCCxHoBruHuw9Kl7juy0M7hpQKWy/AoVxK4wEXoLsW
         2CXNUuDdaxKiC5b6BCNDEb+2Zwl2sIpqfiQ6c=
Date: Wed, 22 Oct 2008 21:01:26 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/17] 2.6.27-stable review
Message-ID: <20081023010126.GB30920@zod.rchland.ibm.com>
References: <20081018183334.GA14035@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 11:33:34AM -0700, Greg KH wrote:
>This is the start of the stable review cycle for the 2.6.27.3 release.
>There are 17 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let us know.  If anyone is a maintainer of the proper subsystem, and
>wants to add a Signed-off-by: line to the patch, please respond with it.
>
>These patches are sent out with a number of different people on the
>Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
>to add your name to the list.  If you want to be off the reviewer list,
>also email us.
>
>Responses should be made by Wed, October 22, 2008 19:00:00 UTC.
>Anything received after that time might be too late.

OK, I realize I'm late.  Apologies in advance for that.

I don't see how patches 3, 16, and 17 really fit into the "stable"
rules.  None of them:

"... fix a problem that causes a build error (but not for things
 marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
 security issue, or some "oh, that's not good" issue.  In short,
 something critical."

So, are we being a bit more lax on the requirements for the
-stable kernels and I missed the memo, or?

josh
