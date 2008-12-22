Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYLVSxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYLVSxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYLVSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:53:40 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45767 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYLVSxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:53:39 -0500
To: peterz@infradead.org
CC: miklos@szeredi.hu, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <1229867858.9487.238.camel@twins> (message from Peter Zijlstra on
	Sun, 21 Dec 2008 14:57:38 +0100)
Subject: Re: [regression] uml is very slow on 2.6.28 host
References: <E1LB4QO-0005fk-7g@pomaz-ex.szeredi.hu> <1229867858.9487.238.camel@twins>
Message-Id: <E1LEpu5-000627-Dn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 22 Dec 2008 19:53:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008, Peter Zijlstra wrote:
> On Fri, 2008-12-12 at 10:35 +0100, Miklos Szeredi wrote:
> > When the UML boot gets to the userspace part it gets really really
> > slow.  It takes about 20 times the normal time to fully boot.  CPU
> > seems to be idle.
> > 
> > Guest version doesn't matter.  Host version 2.6.27 was OK, latest git
> > is not OK.  I'm running 32bit guest on 64bit host.
> 
> Does:
> 
> http://lkml.org/lkml/2008/12/16/40
> 
> help any?

Nope.

Thanks,
Miklos
