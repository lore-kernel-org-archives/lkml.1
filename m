Return-Path: <linux-kernel-owner+w=401wt.eu-S1763616AbXJQGoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763616AbXJQGoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbXJQGoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:44:05 -0400
Received: from lixom.net ([66.141.50.11]:48781 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbXJQGoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:44:05 -0400
Date: Wed, 17 Oct 2007 01:50:15 -0500
From: Olof Johansson <olof@lixom.net>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-git-10 Build Failure on powerpc -
	asm-powerpc/dma_mapping.h
Message-ID: <20071017065015.GA21329@lixom.net>
References: <4715A9C1.9090106@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4715A9C1.9090106@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 17, 2007 at 11:50:49AM +0530, Kamalesh Babulal wrote:

> Build fails on the powerpc fails with 2.6.23-git10

This was fixed by 33ff910f0f466184ffc3514628f18403dcd86761.


-Olof
