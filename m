Return-Path: <linux-kernel-owner+w=401wt.eu-S934374AbYDQRTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374AbYDQRTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761799AbYDQRTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:19:25 -0400
Received: from sous-sol.org ([216.99.217.87]:51999 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761430AbYDQRTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:19:24 -0400
Date: Thu, 17 Apr 2008 10:16:16 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kenichi Ohmichi <oomichi@mxs.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: vmcoreinfo: add the symbol "phys_base"
Message-ID: <20080417171616.GE17220@sequoia.sous-sol.org>
References: <20080417010122.148289106@sous-sol.org> <20080417010334.951283202@sous-sol.org> <m17iewvnot.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17iewvnot.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric W. Biederman (ebiederm@xmission.com) wrote:
> Chris Wright <chrisw@sous-sol.org> writes:
> 
> > -stable review patch.  If anyone has any objections, please let us know.
> > ---------------------
> 
> This patch seems quite reasonable.  However as I read it, it is
> a feature enhancement, that allows a user space tool to function
> better.  Do we backport trivial features into stable now?

Function better, meaning work reliably?  Sounds like a fix not a
feature.

thanks,
-chris
