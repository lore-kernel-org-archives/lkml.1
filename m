Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbXKUGFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbXKUGFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXKUGF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:05:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbXKUGF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:05:27 -0500
Date: Tue, 20 Nov 2007 22:04:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 - Build Failure on S390x
Message-Id: <20071120220455.d73c57e8.akpm@linux-foundation.org>
In-Reply-To: <4743C8A3.60909@linux.vnet.ibm.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743C8A3.60909@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 11:26:51 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> The kernel build fails on S390x, with

Yes, sorry, I forgot to mention that.  I got a large patch reject
between Greg's driver tree and the s390 tree and I couldn't be bothered
fixing it.  s390 is busted in 2.6.24-rc3-mm1.
