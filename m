Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYAGKC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYAGKC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYAGKCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:02:18 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:46342 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754162AbYAGKCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:02:16 -0500
Date: Mon, 7 Jan 2008 15:32:02 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Vivek Goyal <vgoyal@redhat.com>,
       hbabu@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20080107100202.GB30865@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071228124532.GB32643@linux.vnet.ibm.com> <20071231150843.GB27060@redhat.com> <20080103195201.GC6392@linux.vnet.ibm.com> <200801032242.01425.rjw@sisk.pl> <20080104122816.GF4514@linux.vnet.ibm.com> <20080104155415.GC6007@linux.vnet.ibm.com> <20080106133729.GB2481@elte.hu> <20080107091838.GA30865@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107091838.GA30865@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> commit 7dd838ea7afa42a8840cf0e262d5892346ecf379
> Author: H. Peter Anvin <hpa@zytor.com>
> Date:   Sat Jan 5 13:27:04 2008 +0100
> 

sorry, forgot the subject, it is

	i386: handle an initrd in highmem

-- 
regards,
Dhaval
