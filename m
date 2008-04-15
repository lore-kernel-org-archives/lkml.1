Return-Path: <linux-kernel-owner+w=401wt.eu-S1763320AbYDOBJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763320AbYDOBJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYDOBJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:09:26 -0400
Received: from web65604.mail.ac4.yahoo.com ([76.13.9.72]:23961 "HELO
	web65604.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752535AbYDOBJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:09:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=5d941dEsDUj3DBtdira05rt4pPe2+wBe9GVfOalFWfWpCtxwxPvAKPTD71KWJGSnSbzAaJPS2Y9nIcReKRVCogUPcfew5u0JephJLt00SN0tDJPUGhcW5xDS4xy8sL5gKn3BLulT/crQXOqk/Tbknmt7NC2uzkxBGyr7+C4CkhA=;
X-YMail-OSG: o5bPED4VM1mec3GNrliubpCRTOp8F2oyOLPNuv3HWhtZCzENSIQbppVNe5LmytcqF0QUhBRsiqdTlRIWtC6vQM_JSiil4.Y-
Date: Mon, 14 Apr 2008 21:09:23 -0400 (EDT)
From: Paul Gortmaker <p_gortmaker@yahoo.com>
Subject: Re: [2.6 patch] xtensa: don't offer CONFIG_RTC
To: Adrian Bunk <bunk@kernel.org>, chris@zankel.net
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080414195530.GC26885@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <45238.12307.qm@web65604.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/char/rtc.o
> In file included from
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/char/rtc.c:70:
>
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mc146818rtc.h:16:59:
> error: asm/mc146818rtc.h: No such file or directory
> ...
> make[3]: *** [drivers/char/rtc.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by:  Paul Gortmaker <p_gortmaker@yahoo.com>




      __________________________________________________________________
Looking for the perfect gift? Give the gift of Flickr! 

http://www.flickr.com/gift/
