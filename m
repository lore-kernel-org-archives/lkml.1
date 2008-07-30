Return-Path: <linux-kernel-owner+w=401wt.eu-S1761752AbYG3MyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761752AbYG3MyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYG3MyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:54:11 -0400
Received: from venus.billgatliff.com ([209.251.101.201]:51385 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbYG3MyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:54:10 -0400
Message-ID: <48906477.8010203@billgatliff.com>
Date: Wed, 30 Jul 2008 07:54:15 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, vatsa@linux.vnet.ibm.com,
       efault@gmx.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270
 (at least)?
References: <20080729223105.GK10982@flint.arm.linux.org.uk> <20080729154605.d540cf6d.akpm@linux-foundation.org> <20080729225623.GO10982@flint.arm.linux.org.uk> <1217401810.6364.3.camel@twins> <1217404554.6364.18.camel@twins> <20080730080032.GC2274@flint.arm.linux.org.uk>
In-Reply-To: <20080730080032.GC2274@flint.arm.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys:


I just turned off PRINTK_TIME, and verified that the platform boots.

I can live with this workaround short-term, especially if doing so provides time
to find the right fix.  I wouldn't want to see this still broken in .28, of
course...  ;)


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
