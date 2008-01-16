Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYAPUAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYAPUAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYAPT7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:59:52 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38610 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYAPT7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:59:51 -0500
Date: Wed, 16 Jan 2008 12:59:49 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: SLUB: Increasing partial pages
Message-ID: <20080116195949.GO18741@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Christoph,

We tested 2.6.24-rc5 + 76be895001f2b0bee42a7685e942d3e08d5dd46c

For 2.6.24-rc5 before that patch, slub had a performance penalty of
6.19%.  With the patch, slub's performance penalty was reduced to 4.38%.
This is great progress.  Can you think of anything else worth trying?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
