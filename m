Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbZELRWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbZELRWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZELRWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:22:14 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:53249 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751454AbZELRWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:22:14 -0400
Date: Tue, 12 May 2009 17:21:16 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/3] x86: add numa_move_cpus_to_node
In-Reply-To: <4A09AEFB.4070808@kernel.org>
Message-ID: <alpine.DEB.1.10.0905121720430.24066@qirst.com>
References: <4A05269D.8000701@kernel.org> <4A052721.4010201@kernel.org> <alpine.DEB.1.10.0905112126410.28512@qirst.com> <4A089E53.8010106@kernel.org> <alpine.DEB.1.10.0905121658140.14226@qirst.com> <4A09AEFB.4070808@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Yinghai Lu wrote:

> or let user util do that? aka before hotadd mem to that node, use /sys to bring
> the cpu offine and put the cpus online after mem is added ?

Ok then we wont need the kernel.

