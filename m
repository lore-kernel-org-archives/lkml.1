Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYBKKoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYBKKoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYBKKoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:44:25 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46031 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYBKKoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:44:24 -0500
Date: Mon, 11 Feb 2008 16:14:52 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       sam@ravnborg.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 0/8] Create and populate toplevel tests/ for kernel tests
Message-ID: <20080211104452.GB7944@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series of patches create and populate the toplevel tests/
directory. This will henceforth be the place where all in-kernel tests
live.

All patches against 2.6.25-rc1 and are just code movement without any
change in functionality.

Ananth
