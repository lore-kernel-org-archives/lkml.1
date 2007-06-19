Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbXFSNZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbXFSNZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbXFSNZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:25:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60627 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485AbXFSNZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:25:24 -0400
Subject: Re: [patch 2/2] kprobes x86_64 quick fix mark-ro-data
From: Arjan van de Ven <arjan@infradead.org>
To: prasanna@in.ibm.com
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, ananth@in.ibm.com
In-Reply-To: <20070619100810.GA301@in.ibm.com>
References: <20070615202310.178466032@polymtl.ca>
	 <4676D2A9.6090403@redhat.com>
	 <20070618115632.7aca8c0f.akpm@linux-foundation.org>
	 <200706182132.56559.ak@suse.de> <20070619100644.GA5478@in.ibm.com>
	 <20070619100810.GA301@in.ibm.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 19 Jun 2007 06:21:28 -0700
Message-Id: <1182259288.3014.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 15:38 +0530, S. P. Prasanna wrote:
> This patch is a quick fix for x86_64 to enable kprobes only if DEBUG_RODATA is
> not configured. Since DEBUG_RODATA markes the kernel text pages as read-only.


it does??

I don't seem to be able to find this in the source code..... 


