Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZBRFMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZBRFMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 00:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZBRFLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 00:11:52 -0500
Received: from ozlabs.org ([203.10.76.45]:37152 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbZBRFLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 00:11:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Update jhash.h with the new version of Jenkins' hash
Date: Wed, 18 Feb 2009 15:41:44 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <alpine.DEB.2.00.0902111107480.15665@blackhole.kfki.hu> <f73f7ab80902120546w2ac30501v10fc55b9c8270be9@mail.gmail.com> <alpine.DEB.2.00.0902171723330.27283@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.00.0902171723330.27283@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181541.45159.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 03:43:04 Jozsef Kadlecsik wrote:
> On Thu, 12 Feb 2009, Rusty Russell wrote:
> > Any stats on code size changes?
> compiled with -Os, then stripped, give:
> 
> -rw-r--r-- 1 kadlec kadlec 1080 2009-02-17 14:10 lookup2.o
> -rw-r--r-- 1 kadlec kadlec 1024 2009-02-17 14:10 lookup3.o

The "size" command is more usual.  This looks like a total win to me.

Thanks for being so thorough!
Rusty.
