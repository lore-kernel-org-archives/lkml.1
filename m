Return-Path: <linux-kernel-owner+w=401wt.eu-S935110AbXLQCwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935110AbXLQCwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:52:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbXLQCvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:51:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbXLQCvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:51:51 -0500
Date: Sun, 16 Dec 2007 21:51:29 -0500
From: Dave Jones <davej@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation>, protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
Message-ID: <20071217025129.GA12815@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Arjan van de Ven <arjan@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation>, protasnb@gmail.com
References: <4762CF8C.90808@linux.intel.com> <4763F771.10105@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4763F771.10105@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 04:49:05PM +0100, Stefan Richter wrote:
 
 > Reports about tainted kernels have arguably less value.  It would be
 > good to hide such reports until a report of the same oops in an
 > untainted kernel was found.
 
I disagree with this.  It's useful to have a "we've seen this before,
and every time, it was tainted with xyz module" datapoint, especially
if no untainted copies of that oops turn up.

	Dave

-- 
http://www.codemonkey.org.uk
