Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbXENVpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbXENVpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbXENVp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:45:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2763 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbXENVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:45:27 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 14 May 2007 14:45:26 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Christoph Hellwig <hch@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/1] export eventfd symbols ...
In-Reply-To: <20070514214201.GA24107@infradead.org>
Message-ID: <Pine.LNX.4.64.0705141443440.19682@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.25077.1179178493.1>
 <20070514214201.GA24107@infradead.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Christoph Hellwig wrote:

> On Mon, May 14, 2007 at 02:34:53PM -0700, Davide Libenzi wrote:
> > Export eventfd kernel functions to modules.
> 
> Why?

KVM developers asked for it. It seem they'll be using eventfd to signal 
events to userspace.



- Davide


