Return-Path: <linux-kernel-owner+w=401wt.eu-S1763794AbXIKRg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763794AbXIKRg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 13:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbXIKRgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 13:36:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50069 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbXIKRgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 13:36:50 -0400
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
From: Peter Zijlstra <peterz@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
In-Reply-To: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 19:36:42 +0200
Message-Id: <1189532202.21778.84.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 10:16 -0700, Randy Dunlap wrote:

> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +Evolutions (GUI)

I take it you mean: Evolution

> +Some people seem to use this successfully for patches.
> +
> +What config options are needed?

When composing mail select: Preformat 
  from Format->Heading->Preformatted (Ctrl-7)
  or the toolbar

Then use:
  Insert->Text File... (Alt-n x)

to insert the patch.


