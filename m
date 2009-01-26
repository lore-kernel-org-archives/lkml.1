Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbZAZQYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbZAZQYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZAZQYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:24:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:48055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZAZQYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:24:41 -0500
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <200901261653.32856.arnd@arndb.de>
References: <1232496257.3123.19.camel@localhost.localdomain>
	 <497670C6.7010304@zytor.com>
	 <1232723900.3504.4.camel@localhost.localdomain>
	 <200901261653.32856.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 21:54:05 +0530
Message-Id: <1232987045.5337.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 16:53 +0100, Arnd Bergmann wrote:
> > 
> > 2. #if __BITS_PER_LONG == 64
> 
> my suggestion, looks good

Thanks for confirmation, now I will prepare patchset based on
__BITS_PER_LONG :-)

--
JSR

