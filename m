Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbYCRLRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbYCRLRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYCRLQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:16:57 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:40513 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYCRLQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:16:56 -0400
Message-ID: <47DFA49D.4000007@linux.vnet.ibm.com>
Date: Tue, 18 Mar 2008 16:46:45 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       stern@rowland.harvard.edu, Andy Whitcroft <apw@shadowen.org>,
       lenb@kernel.org, greg@kroah.com, akpm@linux-foundation.org, rjw@sisk.pl
Subject: [Build Failure] linux-next: Tree for March 18 
References: <20080318205259.13726d23.sfr@canb.auug.org.au>
In-Reply-To: <20080318205259.13726d23.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

The kernel build of linux-next tree(s) have been failing from 20080314 with
the build failure

drivers/serial/serial_core.c: In function `uart_add_one_port':
drivers/serial/serial_core.c:2359: error: invalid lvalue in assignment
make[2]: *** [drivers/serial/serial_core.o] Error 1

And the patch was submitted for the same http://marc.info/?l=linux-next&m=120561799422065&w=2

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
