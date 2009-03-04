Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZCDBAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZCDBAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZCDBAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:00:03 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:54340 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZCDBAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:00:01 -0500
Subject: Re: [PATCH 1/3] s390: Expose a constant for the number of words
	representing the CRs
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Dan Smith <danms@us.ibm.com>
Cc: containers@lists.osdl.org, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <87d4cyrtr0.fsf@caffeine.danplanet.com>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
	 <1236095764-19325-2-git-send-email-danms@us.ibm.com>
	 <1236096494.22399.5.camel@nimitz>  <87d4cyrtr0.fsf@caffeine.danplanet.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 16:59:56 -0800
Message-Id: <1236128396.22399.29.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 16:56 -0800, Dan Smith wrote:
> DH> This doesn't do a lot of good unless it gets used in the base s390
> DH> code.  Otherwise, why not just define it near its use in the c/r
> DH> code?
> 
> I intended to replace all uses, but I just found one place I missed,
> but I think that's it.  If you know of other places that it's used in
> the s390 code, other than in compat_ptrace.h and ptrace.h please point
> them out.

My only knowledge of where else it was used came from you. :)

-- Dave

