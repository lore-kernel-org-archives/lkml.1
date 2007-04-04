Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbXDDSr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbXDDSr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbXDDSr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:47:28 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52066 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbXDDSr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:47:26 -0400
Date: Wed, 4 Apr 2007 11:47:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomas M <tomas@slax.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ken Chen <kenchen@google.com>
Subject: Re: [patch] remove artificial software max_loop limit
Message-Id: <20070404114711.1050db32.akpm@linux-foundation.org>
In-Reply-To: <46137E7D.8090809@slax.org>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
	<b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
	<Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
	<b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
	<20070330141524.5f6cff29.akpm@linux-foundation.org>
	<20070331170743.GB14596@kroah.com>
	<20070331104144.46c85f27.akpm@linux-foundation.org>
	<b040c32a0703312116y56bad12h9d370a8a2c99b245@mail.gmail.com>
	<46137E7D.8090809@slax.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 12:31:25 +0200 Tomas M <tomas@slax.org> wrote:

>  > OK, here is a re-spin patch that I tested as module or
>  > link-in-vmlinux.  Both produce satisfactory result for me.
> 
> Is there a plan to include this brilliant code in mainline Kernel?
> It works excellent, tested with 15000 loop devices, it's simply cool.

I ecpect it will join all the other brilliant code in 2.6.22 ;)
