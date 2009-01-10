Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZAJFv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZAJFv3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbZAJFvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:51:21 -0500
Received: from ozlabs.org ([203.10.76.45]:50397 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZAJFvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:51:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18792.14162.970161.966309@cargo.ozlabs.ibm.com>
Date: Sat, 10 Jan 2009 16:51:14 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/9] Performance counters for POWER
In-Reply-To: <20090109134727.GA902@elte.hu>
References: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
	<20090109134727.GA902@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Also, would this be the right moment for me to pull from you?

I fixed the bugs and pushed out the updated commits, so yes please do
the pull.  Note that I did a forced update, so fetch again if you
fetched previously.

Paul.
