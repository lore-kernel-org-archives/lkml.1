Return-Path: <linux-kernel-owner+w=401wt.eu-S1762040AbXFSFsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762040AbXFSFsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 01:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXFSFsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 01:48:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59317 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbXFSFsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 01:48:31 -0400
To: clameter@sgi.com
Subject: Re: [patch 05/26] Slab allocators: Cleanup zeroing allocations
X-IlohaMail-Blah: penberg@cs.helsinki.fi
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.12+pk-11 (On: iloha.cs.Helsinki.FI)
In-Reply-To: <Pine.LNX.4.64.0706181531410.8595@schroedinger.engr.sgi.com>
Message-ID: <YwzqCzcS.1182232109.9199150.penberg@cs.helsinki.fi>
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Tue, 19 Jun 2007 08:48:29 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/19/2007, "Christoph Lameter" <clameter@sgi.com> wrote:
> IA64

[snip]

> Saved ~500 bytes in text size.
> 
> x86_64:

[snip]

> 200 bytes saved.

Looks good. Thanks Christoph.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
