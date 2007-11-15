Return-Path: <linux-kernel-owner+w=401wt.eu-S934113AbXKPACU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113AbXKPACU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762938AbXKPACJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:02:09 -0500
Received: from ozlabs.org ([203.10.76.45]:55908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbXKPACH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:02:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18236.55874.204068.358524@cargo.ozlabs.ibm.com>
Date: Fri, 16 Nov 2007 10:46:10 +1100
From: Paul Mackerras <paulus@samba.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@samba.org>, linuxppc <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc1 on PPC64: machine check exception
In-Reply-To: <473C7B16.3050700@linux.vnet.ibm.com>
References: <472F1F4C.3010507@linux.vnet.ibm.com>
	<20071105154055.GA4746@kryten>
	<472F5C5E.4030607@linux.vnet.ibm.com>
	<473C7B16.3050700@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan writes:

> This patch fixed the problem.  I am able to run and profile ebizzy on 128-way
> PPC64.  However this fix is not included in 2.6.24-rc2 as well.
> I will watch for inclusion of this fix in 2.6.24.

It's upstream in Linus' tree now, so it will be in -rc3.

Paul.
