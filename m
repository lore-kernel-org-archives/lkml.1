Return-Path: <linux-kernel-owner+w=401wt.eu-S1763937AbYBFX2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763937AbYBFX2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbYBFX2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:28:23 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39165 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757027AbYBFX2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:28:22 -0500
Date: Wed, 6 Feb 2008 15:28:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: Greg KH <greg@kroah.com>, "Justin M. Forbes" <jmforbes@linuxtx.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, torvalds@linux-foundation.org,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhaval@linux.vnet.ibm.com
Subject: Re: [patch 22/27] quicklist: Set tlb->need_flush if pages are
 remaining in quicklist 0
In-Reply-To: <6101e8c40802061511k6356cd5cued8d9eb646a27bc9@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802061528160.22648@schroedinger.engr.sgi.com>
References: <20080202001232.472591439@mini.kroah.org>  <20080202002103.GW8368@suse.de>
  <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com> 
 <1201915720.3781.18.camel@turion.linuxtx.org> 
 <Pine.LNX.4.64.0802011729560.21840@schroedinger.engr.sgi.com> 
 <20080206224520.GA11045@kroah.com> <6101e8c40802061511k6356cd5cued8d9eb646a27bc9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct


