Return-Path: <linux-kernel-owner+w=401wt.eu-S965985AbXCPWKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965985AbXCPWKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965988AbXCPWKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:10:54 -0400
Received: from gw.goop.org ([64.81.55.164]:48245 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965985AbXCPWKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:10:54 -0400
Message-ID: <45FB15E8.4080406@goop.org>
Date: Fri, 16 Mar 2007 15:10:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 03/26] Xen-paravirt_ops: use paravirt_nop to consistently
 mark no-op operations
References: <20070301232443.195603797@goop.org> <20070301232526.261284776@goop.org> <20070316094432.GU23174@elte.hu> <45FAE560.10401@goop.org> <20070316194904.GO10574@sequoia.sous-sol.org> <45FAF77A.8010607@goop.org> <20070316215916.GP10574@sequoia.sous-sol.org>
In-Reply-To: <20070316215916.GP10574@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> I mean like this (bunch of work, for a type check that we're really ignoring
> anwyay, but this is the idea...)
>   

Oh, I see.  I think this is the best argument yet for the current
arrangement...

    J
