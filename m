Return-Path: <linux-kernel-owner+w=401wt.eu-S965132AbXBSWmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132AbXBSWmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965129AbXBSWmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:42:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965132AbXBSWmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:42:03 -0500
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Leonid Ananiev <leonid.i.ananiev@intel.com>
Subject: Re: [PATCH 1/2] aio: create aio_ring_insert_entry() function
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <20070219213830.4032.71308.sendpatchset@tetsuo.zabbo.net>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Mon, 19 Feb 2007 17:41:04 -0500
In-Reply-To: <20070219213830.4032.71308.sendpatchset@tetsuo.zabbo.net> (Zach Brown's message of "Mon, 19 Feb 2007 13:38:30 -0800 (PST)")
Message-ID: <x49649x6a9r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

==> On Mon, 19 Feb 2007 13:38:30 -0800 (PST), Zach Brown <zach.brown@oracle.com> said:

Zach> This patch just hoists the process of inserting an entry into the completion
Zach> ring into its own function.  No functionality is changed.  This is in
Zach> preparation for calling ring insertion from another path with slightly
Zach> different mechanics.

Looks harmless.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
