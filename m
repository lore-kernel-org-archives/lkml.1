Return-Path: <linux-kernel-owner+w=401wt.eu-S932269AbYBBAjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbYBBAjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbYBBAjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:39:14 -0500
Received: from relay1.sgi.com ([192.48.171.29]:43479 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932637AbYBBAjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:39:12 -0500
Date: Fri, 1 Feb 2008 16:39:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
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
In-Reply-To: <20080202002103.GW8368@suse.de>
Message-ID: <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com>
References: <20080202001232.472591439@mini.kroah.org> <20080202002103.GW8368@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NO! Wrong fix. Was dropped from mainline.

