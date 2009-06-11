Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZFKNJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZFKNJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZFKNI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:08:59 -0400
Received: from ozlabs.org ([203.10.76.45]:36439 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbZFKNI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:08:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: rr tree build failure
Date: Thu, 11 Jun 2009 22:38:56 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090611190728.510af289.sfr@canb.auug.org.au>
In-Reply-To: <20090611190728.510af289.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906112238.57075.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009 06:37:28 pm Stephen Rothwell wrote:
> Hi Rusty,
>
> Today's linux-next build (sparc defconfig) failed like this:
>
> arch/sparc/mm/extable.c: In function 'trim_init_extable':
> arch/sparc/mm/extable.c:78: error: too few arguments to function
> 'within_module_init'

Thanks, I've applied your fix.

Thanks,
Rusty.
