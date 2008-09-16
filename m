Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbYIPOTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbYIPOTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYIPOSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:18:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:49038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbYIPOSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:18:45 -0400
Date: Tue, 16 Sep 2008 07:18:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Xu Yang" <risingsunxy@googlemail.com>
Cc: "Bernd Petrovitsch" <bernd@firmix.at>, linux-kernel@vger.kernel.org
Subject: Re: looking for a function
Message-ID: <20080916071847.4a6ed31c@infradead.org>
In-Reply-To: <ab40e9c0809160711p4182d9e7n9b3ce965b3ce9f1f@mail.gmail.com>
References: <ab40e9c0809160550q411507aeledae30a9f835d09d@mail.gmail.com>
	<1221573632.6103.83.camel@spike.firmix.at>
	<ab40e9c0809160711p4182d9e7n9b3ce965b3ce9f1f@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 16:11:10 +0200
"Xu Yang" <risingsunxy@googlemail.com> wrote:

> Hi Bernd,
> 
> thanks for you reply.
> 
> yes, I know the thread migrates all the time, this is exactly what I
> would like to observe. I would like to learn about the thread
> migration of some specific scheduling algorithm. so ....
> 
> any idea about the function?

the getcpu() system call will do what you want.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
