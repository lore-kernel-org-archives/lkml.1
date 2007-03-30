Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbXC3Kck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbXC3Kck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 06:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbXC3Kck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 06:32:40 -0400
Received: from ozlabs.org ([203.10.76.45]:57163 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXC3Kci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 06:32:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17932.54606.323431.491736@cargo.ozlabs.ibm.com>
Date: Fri, 30 Mar 2007 19:15:58 +1000
From: Paul Mackerras <paulus@samba.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: Interface for the new fallocate() system call
In-Reply-To: <20070330071929.GC8365@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
	<20070317111036.GC29931@parisc-linux.org>
	<20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071929.GC8365@osiris.boeblingen.de.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens writes:

> If possible I'd prefer the six-32-bit-args approach.

It does mean extra unnecessary work for 64-bit platforms, though...

Paul.
