Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbYBBBvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbYBBBvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYBBBv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:51:29 -0500
Received: from www.linuxtx.org ([65.99.219.143]:39317 "EHLO mail.linuxtx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbYBBBv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:51:28 -0500
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 20:51:28 EST
Subject: Re: [patch 22/27] quicklist: Set tlb->need_flush if pages are
	remaining in quicklist 0
From: "Justin M. Forbes" <jmforbes@linuxtx.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhaval@linux.vnet.ibm.com
In-Reply-To: <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com>
References: <20080202001232.472591439@mini.kroah.org>
	 <20080202002103.GW8368@suse.de>
	 <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 19:28:40 -0600
Message-Id: <1201915720.3781.18.camel@turion.linuxtx.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-01 at 16:39 -0800, Christoph Lameter wrote:
> NO! Wrong fix. Was dropped from mainline.

What is the right fix for the OOM issues with 2.6.22? Perhaps
http://marc.info/?l=linux-mm&m=119973653803451&w=2 should be added to
the queue in its place?  The OOM issue in 2.6.22 is real, and should be
addressed.

Justin

