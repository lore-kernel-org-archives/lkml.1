Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZEHPYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZEHPYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762747AbZEHPXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:23:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53369 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489AbZEHPXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:23:49 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 8 May 2009 08:19:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Hiroyuki Machida <Hiroyuki.Mach@gmail.com>
cc: rohit verma <rohit.170309@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll_create(0) becomes not to fail (Re: issue with epoll system
  call)
In-Reply-To: <feaf5ed90905080049j78a4ab54x53ce65f22a3ea6a4@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0905080817380.16601@makko.or.mcafeemobile.com>
References: <feaf5ed90905080049j78a4ab54x53ce65f22a3ea6a4@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Hiroyuki Machida wrote:

> Hi  Verma,
> 
> I think your point is right. but descriptions looks not straight forward.
> And title of the message is very confusable.
> I think descriptions like following would be easy to understand, and
> you should attach a your signed-off patch to fix the bug.

Thanks, will take care of it. Unless you want to do me a favour and post a 
properly formatted patch that I can ACK. Both the ones I've seen do not 
fit the bill.


- Davide


