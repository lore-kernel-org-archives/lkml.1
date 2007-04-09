Return-Path: <linux-kernel-owner+w=401wt.eu-S933869AbXDIPg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbXDIPg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933865AbXDIPg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:36:28 -0400
Received: from ozlabs.org ([203.10.76.45]:44304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXDIPg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:36:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <17946.14646.808334.441833@cargo.ozlabs.ibm.com>
Date: Mon, 9 Apr 2007 23:01:42 +1000
From: Paul Mackerras <paulus@samba.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: Interface for the new fallocate() system call
In-Reply-To: <20070330104449.GA9371@lazybastard.org>
References: <20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
	<20070317111036.GC29931@parisc-linux.org>
	<20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071929.GC8365@osiris.boeblingen.de.ibm.com>
	<17932.54606.323431.491736@cargo.ozlabs.ibm.com>
	<20070330104449.GA9371@lazybastard.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel writes:

> Wouldn't that work be confined to fallocate()?  If I understand Heiko
> correctly, the alternative would slow s390 down for every syscall,
> including more performance-critical ones.

The alternative that Jakub suggested wouldn't slow s390 down.

Paul.
