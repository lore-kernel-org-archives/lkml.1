Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbYBBAw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbYBBAw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbYBBAwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:52:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbYBBAwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:52:19 -0500
Date: Fri, 1 Feb 2008 16:50:37 -0800
From: Greg KH <gregkh@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhaval@linux.vnet.ibm.com
Subject: Re: [patch 22/27] quicklist: Set tlb->need_flush if pages are
	remaining in quicklist 0
Message-ID: <20080202005037.GB10071@suse.de>
References: <20080202001232.472591439@mini.kroah.org> <20080202002103.GW8368@suse.de> <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 04:39:08PM -0800, Christoph Lameter wrote:
> NO! Wrong fix. Was dropped from mainline.

Thanks for letting us know, now dropped.

greg k-h
