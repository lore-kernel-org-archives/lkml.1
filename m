Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbYKLKlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbYKLKlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYKLKlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:41:05 -0500
Received: from ozlabs.org ([203.10.76.45]:60836 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYKLKlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:41:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: linux-next: Tree for November 12 - lguest build failure
Date: Wed, 12 Nov 2008 21:10:55 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au, lguest@ozlabs.org
References: <20081112182818.6e259488.sfr@canb.auug.org.au> <20081112091102.GA8063@linux.vnet.ibm.com>
In-Reply-To: <20081112091102.GA8063@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811122110.56290.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008 19:41:02 Kamalesh Babulal wrote:
> Hi Rusty,
>
>  lguest build fails with next-20081112 kernel,
>
> drivers/lguest/lguest_device.c: In function ‘lg_find_vq’:
> drivers/lguest/lguest_device.c:252: error: too many arguments to function
> ‘vring_size’ make[2]: *** [drivers/lguest/lguest_device.o] Error 1

Hey, what idiot put in a patch which broke lguest?  Oh wait...

Thanks, applied!
Rusty.
