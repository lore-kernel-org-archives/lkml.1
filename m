Return-Path: <linux-kernel-owner+w=401wt.eu-S1762526AbYBAX1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762526AbYBAX1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762283AbYBAX1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:27:16 -0500
Received: from lixom.net ([66.141.50.11]:34636 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761315AbYBAX1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:27:14 -0500
Date: Fri, 1 Feb 2008 17:27:41 -0600
From: Olof Johansson <olof@lixom.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build error on PowerPC
Message-ID: <20080201232741.GA7853@lixom.net>
References: <1201866279.6218.187.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201866279.6218.187.camel@violet>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please define what kernel version and what config you're trying to
build.

Also, please cc linuxppc-dev@ozlabs.org for powerpc issues.


Thanks,

Olof

On Fri, Feb 01, 2008 at 12:44:39PM +0100, Marcel Holtmann wrote:
> Hi,
> 
> I get the following build error on PowerPC:
> 
>   CC [M]  sound/ppc/awacs.o
> In file included from sound/ppc/awacs.c:25:
> include/asm/nvram.h:62: error: field ???partition??? has incomplete type
> make[2]: *** [sound/ppc/awacs.o] Error 1
> make[1]: *** [sound/ppc] Error 2
> make: *** [sound] Error 2
> 
> Regards
> 
> Marcel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
