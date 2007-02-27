Return-Path: <linux-kernel-owner+w=401wt.eu-S1751400AbXB0A3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbXB0A3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXB0A3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:29:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:59062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXB0A27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:28:59 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/9] fix umask when noACL kernel meets extN tuned for ACLs
Date: Mon, 26 Feb 2007 16:28:10 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Chris Wright <chrisw@sous-sol.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Hugh Dickins <hugh@veritas.com>
References: <20070226235248.438556696@mini.kroah.org> <20070227000614.GB6283@kroah.com>
In-Reply-To: <20070227000614.GB6283@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261628.11732.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 February 2007 16:06, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.

Should be fine.

Thanks,
Andreas
