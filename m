Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYBKPCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYBKPCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYBKPCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:02:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37034 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYBKPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:02:38 -0500
Date: Mon, 11 Feb 2008 07:01:53 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: ananth@in.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       sam@ravnborg.org
Subject: Re: [PATCH 8/8] Move RODATA and NX tests to tests/
Message-ID: <20080211070153.1fb6a0fc@laptopd505.fenrus.org>
In-Reply-To: <20080211105229.GJ7944@in.ibm.com>
References: <20080211104452.GB7944@in.ibm.com>
	<20080211105229.GJ7944@in.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 16:22:29 +0530
Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Move RODATA and NX testcases to tests/
> 

for the NX test I can see this; for RODATA...
that one is not really stand alone, but integrated with the rest of the rodata code.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
