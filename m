Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbYG3Muq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbYG3Muq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYG3Muj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:50:39 -0400
Received: from venus.billgatliff.com ([209.251.101.201]:50812 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYG3Mui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:50:38 -0400
X-Greylist: delayed 1465 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2008 08:50:38 EDT
Message-ID: <48905DE9.2030503@billgatliff.com>
Date: Wed, 30 Jul 2008 07:26:17 -0500
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

Russell King - ARM Linux wrote:
> On Wed, Jul 30, 2008 at 09:55:54AM +0200, Peter Zijlstra wrote:
>> Sorry - that's only relevant for HAVE_UNSTABLE_SCHED_CLOCK and x86 seems
>> to be the only one using that (which just shows the platforms quality
>> </sarcasm>).

Hmmm.  That one defaults to =y, right?  It has for me for years...  :)


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
