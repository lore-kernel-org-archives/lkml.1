Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbXI0QnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbXI0QnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbXI0QnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:43:00 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51583 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbXI0Qm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:42:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Sep 2007 09:42:56 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: rdunlap@xenotime.net, Andrew Morton <akpm@linux-foundation.org>,
       hch@lst.de, geoff@gclare.org.uk, tglx@linutronix.de, david@hardeman.nu,
       Ulrich Drepper <drepper@redhat.com>, subrata@linux.vnet.ibm.com,
       corbet@lwn.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tristan Wibberley <maihem-nn1@maihem.org>
Subject: Re: Man page for revised timerfd API
In-Reply-To: <20070927072726.50350@gmx.net>
Message-ID: <Pine.LNX.4.64.0709270942150.763@alien.or.mcafeemobile.com>
References: <20070927072726.50350@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Michael Kerrisk wrote:

> Hi Davide,
> 
> A follow up to the man page text.  Does passing a timerfd file
> descriptor via a Unix domain socket to another process do the
> expected thing?  That is, the receiving process will be able to 
> read from the file descriptor in order to obtain notification
> of timer expirations that are occurring for the process
> that sent the file descriptor, right?

Yup.



- Davide


