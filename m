Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYG0DO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYG0DO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 23:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYG0DOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 23:14:20 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42766 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbYG0DOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 23:14:20 -0400
Subject: Re: How to get a sense of VM pressure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Memory Management List <linux-mm@kvack.org>
In-Reply-To: <200807261425.26318.nickpiggin@yahoo.com.au>
References: <488A1398.7020004@goop.org>
	 <200807261425.26318.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 20:14:12 -0700
Message-Id: <1217128452.23502.4.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-26 at 14:25 +1000, Nick Piggin wrote:
> Google I think and maybe IBM (can't remember) is using the proc pagemap
> interfaces to help with this. Probably it is super secret code that can't
> be released though -- but it gives you somewhere to look.

Nobody at IBM that I know. :)  I have other nefarious purposes for it,
but not for memory pressure.

-- Dave

