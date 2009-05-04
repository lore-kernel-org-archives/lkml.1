Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZEDOCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZEDOCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZEDOCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:02:06 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:53195 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbZEDOCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:02:05 -0400
Date: Mon, 4 May 2009 09:50:29 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] vmscan: don't export nr_saved_scan in
 /proc/zoneinfo
In-Reply-To: <20090502024719.GA29730@localhost>
Message-ID: <alpine.DEB.1.10.0905040950200.9553@qirst.com>
References: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org> <20090501012212.GA5848@localhost> <20090430194907.82b31565.akpm@linux-foundation.org> <20090502023125.GA29674@localhost> <20090502024719.GA29730@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Lameter <cl@linux-foundation.org>


