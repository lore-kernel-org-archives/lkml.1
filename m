Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbXIIIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbXIIIEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbXIIIE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 04:04:28 -0400
Received: from mail.suse.de ([195.135.220.2]:60638 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbXIIIE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 04:04:27 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] remove asm/bitops.h includes
References: <30483262301654323266@pripojeni.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Sep 2007 10:04:25 +0200
In-Reply-To: <30483262301654323266@pripojeni.net>
Message-ID: <p738x7gs1rq.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> remove asm/bitops.h includes
> 
> including asm/bitops directly may cause compile errors. 

When does it cause compile errors? It would be probably less 
intrusive to just fix that case.

-Andi
