Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbXJHN2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbXJHN2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 09:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXJHN2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 09:28:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:38454 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXJHN2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 09:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=AYf4lC8xb6wJSWb76l3GnkD6/0Q5XbB9BZ0QPFwSBwYaDB/4mICY4ita8MoD2uVeYzJjDCycShQq93ymXyKEj5+/z4bSLdBt/zHl9HhjkbKU2Y1iBvNGJ3JVKKZrLnfkxL8cxSvcR4/uc6xYyIkasw4BA9pxq3d6Lc7spjlhPEY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/2] Colored kernel output (run2)
Date: Mon, 8 Oct 2007 14:28:01 +0100
User-Agent: KMail/1.9.1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Oleg Verych <olecom@flower.upol.cz>,
       Ingo Molnar <mingo@elte.hu>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0710062108130.5969@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710062108130.5969@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710081428.02129.vda.linux@googlemail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 October 2007 20:13, Jan Engelhardt wrote:
> Colored kernel message output (1/2)
> 
> This patch makes it possible to give kernel messages a selectable
> color. It can be chosen at compile time, overridden at boot time,
> and changed at run time.

IMHO: useless bloat.

And yes, I've read entire thread. Sorry.
--
vda
