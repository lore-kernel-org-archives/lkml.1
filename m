Return-Path: <linux-kernel-owner+w=401wt.eu-S2992807AbXCCAkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992807AbXCCAkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 19:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992808AbXCCAkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 19:40:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49978 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992807AbXCCAkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 19:40:11 -0500
Date: Fri, 2 Mar 2007 16:40:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070302164009.a2aa6cbc.akpm@linux-foundation.org>
In-Reply-To: <6bffcb0e0703021542k4f882531r21807c7efdbd0ebc@mail.gmail.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<6bffcb0e0703021542k4f882531r21807c7efdbd0ebc@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007 00:42:33 +0100
"Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> On 02/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Temporarily at
> >
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> >
> 
> I have noticed some strange system behavior. When i try to build a
> kernel (medium load) - X, keyboard, mouse and sound hangs.
> 
> I can ping machine and I can use magic SysRq key, but that's all.
> 
> 2.6.20-mm2 was fine, 2.6.21-rc2 works well (over 800 patches since
> 2.6.20-mm2 - great...)
> 
> NIL (Nothing Interesting in Logs)
> 

Can we see the sysrq-T output please?
