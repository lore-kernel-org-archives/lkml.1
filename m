Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZAAB04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZAAB04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 20:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZAAB0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 20:26:47 -0500
Received: from ozlabs.org ([203.10.76.45]:58312 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZAAB0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 20:26:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18780.7119.389420.458007@cargo.ozlabs.ibm.com>
Date: Thu, 1 Jan 2009 12:26:39 +1100
From: Paul Mackerras <paulus@samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/1] work_on_cpu: use on PowerPC
In-Reply-To: <200812312340.44056.rusty@rustcorp.com.au>
References: <200812011917.23507.rusty@rustcorp.com.au>
	<200812312340.44056.rusty@rustcorp.com.au>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell writes:

> Hmm, I didn't see this in Linus' tree.  No urgency, but just a reminder.
> 
> Subject: work_on_cpu: use on PowerPC

Thanks.  For future reference, it's helpful if you cc
linuxppc-dev@ozlabs.org because then it shows up in patchwork
(http://patchwork.ozlabs.org/project/linuxppc-dev/list/) which is what
I look at when I collect patches to send upstream.

Paul.
