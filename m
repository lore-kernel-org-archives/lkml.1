Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYE3NyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYE3NyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYE3NyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:54:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57930 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbYE3NyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:54:09 -0400
Message-ID: <484006C8.7070006@garzik.org>
Date: Fri, 30 May 2008 09:53:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
References: <1211995212.3445.52.camel@localhost.localdomain>	 <20080528.225826.40264516.davem@davemloft.net>	 <1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu>	 <1212077700.26088.83.camel@shinybook.infradead.org>	 <483F002E.5060002@garzik.org>	 <1212095864.24826.2.camel@lappy.programming.kicks-ass.net>	 <483F3EC4.5050700@zytor.com>  <20080530103107.4f71cfe3@core> <1212141059.12349.240.camel@twins>
In-Reply-To: <1212141059.12349.240.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> It's what benh said; I just want a single netbootable image. And cross
> buildling initrds is just impossible - which makes the whole solution
> useless.


hpa's klibc solution was cross-buildable IIRC.

	Jeff



