Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYEHILx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYEHILx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYEHILi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:11:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50506
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbYEHILf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:11:35 -0400
Date: Thu, 08 May 2008 01:11:29 -0700 (PDT)
Message-Id: <20080508.011129.112595455.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, jdassen@debian.org
Subject: Re: + net-ipv4-correct-rfc-1122-section-reference-in-comment.patch
 added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805072127.m47LRVDR017266@imap1.linux-foundation.org>
References: <200805072127.m47LRVDR017266@imap1.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Wed, 07 May 2008 14:27:31 -0700

> Subject: net/ipv4: correct RFC 1122 section reference in comment
> From: J.H.M. Dassen (Ray) <jdassen@debian.org>
> 
> RFC 1122 does not have a section 3.1.2.2. The requirement to silently
> discard datagrams with a bad checksum is in section 3.2.1.2 instead.
> 
> Addresses http://bugzilla.kernel.org/show_bug.cgi?id=10611
> 
> Signed-off-by: J.H.M. Dassen (Ray) <jdassen@debian.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Andrew, I've added this to net-2.6, thanks for keeping
track of it.
