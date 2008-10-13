Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbYJMWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbYJMWDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYJMWDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:03:01 -0400
Received: from ozlabs.org ([203.10.76.45]:40786 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbYJMWDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:03:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18675.50571.890312.526501@cargo.ozlabs.ibm.com>
Date: Tue, 14 Oct 2008 09:02:51 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] intermediate SCSI updates
In-Reply-To: <alpine.LFD.2.00.0810131416410.3288@nehalem.linux-foundation.org>
References: <1223909115.5566.13.camel@localhost.localdomain>
	<alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
	<1223925606.5566.20.camel@localhost.localdomain>
	<alpine.LFD.2.00.0810131416410.3288@nehalem.linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> Is linux-next coverage REALLY so weak that it doesn't even test the 
> default config options, much less any random options? What's the point of 
> linux-next then?

Stephen has been on vacation since the kernel summit, so linux-next
hasn't been happening for the past few weeks.

Paul.
