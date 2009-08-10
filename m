Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbZHJMhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbZHJMhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZHJMhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:37:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36957 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZHJMhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:37:20 -0400
Subject: Re: [BUILD FAIL] Linus git Tree on x86_32 for randconfig dated
 10/08/2009
From: Peter Zijlstra <peterz@infradead.org>
To: subrata@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       balbir <balbir@linux.vnet.ibm.com>
In-Reply-To: <1249905728.5187.21.camel@subratamodak.linux.ibm.com>
References: <1249905728.5187.21.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 Aug 2009 14:36:52 +0200
Message-Id: <1249907812.17467.126.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 17:32 +0530, Subrata Modak wrote:
> Hi Greg/Ingo,
> 
> Todayś Linus git tree produced the following build failure on
> randconfig:
> 
> ......
> ......
> (.text+0xf280): multiple definition of `CmmRxnonRalinkFrameIndicate'
> drivers/staging/rt2860/built-in.o:(.text+0x12d3f): first defined here
> drivers/staging/rt2870/built-in.o: In function `RTMPEnableRxTx':

Its staging, what do you expect ;-)
