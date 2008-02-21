Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbYBUDu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbYBUDu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 22:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYBUDuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 22:50:11 -0500
Received: from ozlabs.org ([203.10.76.45]:55167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYBUDuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 22:50:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18364.57054.427433.405627@cargo.ozlabs.ibm.com>
Date: Thu, 21 Feb 2008 13:15:58 +1100
From: Paul Mackerras <paulus@samba.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2][POWERPC] Fix initial lmb add region with a non-zero
	base
In-Reply-To: <4130F47E-4F4A-4911-B63B-403A8C423565@kernel.crashing.org>
References: <Pine.LNX.4.64.0802191350590.10089@blarg.am.freescale.net>
	<20080219.163003.152862383.davem@davemloft.net>
	<4130F47E-4F4A-4911-B63B-403A8C423565@kernel.crashing.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala writes:

> np.  Are we trying to get this into 2.6.25 or .26?

I was going to put it into my powerpc-next branch and put it in
2.6.26.  I don't see any need for it to go in 2.6.25.

Paul.
