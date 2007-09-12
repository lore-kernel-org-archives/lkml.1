Return-Path: <linux-kernel-owner+w=401wt.eu-S934807AbXILQVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807AbXILQVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764298AbXILQVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:21:32 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:44867 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbXILQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:21:31 -0400
Subject: Re: hci_sock.c build failure
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: greg@kroah.com, andre@finow14.de, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070912.051212.112608750.davem@davemloft.net>
References: <20070912092929.GA2878@ahaupt-debian-vm.localdomain>
	 <20070912120253.GA13003@kroah.com>
	 <20070912.051212.112608750.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 12 Sep 2007 18:20:19 +0200
Message-Id: <1189614019.12789.57.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > It's not even a randconfig issue, my build dies too (this is Linus's
> > current tree.)
> > 
> > Time to poke through the 10 bluetooth patches that were just added...
> 
> I'll push the following fix to Linus.

the patch looks absolutely fine to me. You can put an Acked-by line to
it. Sorry for breaking the build. I tested it on so many architectures,
but it seems I always had CONFIG_COMPAT enabled. Seems I am running out
of i386/32-bit only systems.

Regards

Marcel


