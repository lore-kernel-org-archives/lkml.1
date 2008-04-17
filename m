Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYDQXiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYDQXiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 19:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYDQXiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 19:38:46 -0400
Received: from sous-sol.org ([216.99.217.87]:53354 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbYDQXip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 19:38:45 -0400
Date: Thu, 17 Apr 2008 16:33:46 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joy Latten <latten@austin.ibm.com>
Subject: Re: CRYPTO xcbc: Fix crash when ipsec uses xcbc-mac with big data
	chunk
Message-ID: <20080417233346.GI17220@sequoia.sous-sol.org>
References: <20080417010122.148289106@sous-sol.org> <20080417010337.793546930@sous-sol.org> <200804171426.15334.caglar@pardus.org.tr> <20080417142259.GA12808@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417142259.GA12808@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Sorry, my fault.  That should've been sg_next for 2.6.24.

Thanks, fixed it up.
-chris
