Return-Path: <linux-kernel-owner+w=401wt.eu-S1031405AbXFHSZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031405AbXFHSZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968937AbXFHSYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:24:55 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:43613 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968589AbXFHSYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:24:54 -0400
Date: Fri, 8 Jun 2007 11:23:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Theodore Tso <tytso@mit.edu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 34/54] Fix roundup_pow_of_two(1)
Message-ID: <20070608182325.GH3723@sequoia.sous-sol.org>
References: <20070608072127.352723000@sous-sol.org> <20070608072220.006310000@sous-sol.org> <20070608081944.GA12687@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608081944.GA12687@thunk.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Theodore Tso (tytso@mit.edu) wrote:
> If this doesn't fix a user-visiable bug, should we be including it in
> the stable patch series?  (Assuming that it doesn't, I wouldn't, but I
> tend to be more conservative about what I would include in a stable
> production release.)

Rolf, despite simplicity of patch, I'm inclined to agree with Ted.
Were you effected by this in the wild, or just noticed by code
inspection?

thanks,
-chris
