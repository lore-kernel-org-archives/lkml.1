Return-Path: <linux-kernel-owner+w=401wt.eu-S1763094AbXFRLpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094AbXFRLpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761077AbXFRLpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:45:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:24306 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbXFRLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:45:20 -0400
Date: Mon, 18 Jun 2007 13:45:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Miklos Szeredi <miklos@szeredi.hu>, davem@davemloft.net,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
In-Reply-To: <20070618124721.56411b93@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706181344500.5731@fbirervta.pbzchgretzou.qr>
References: <E1I0BzQ-0006gZ-00@dorka.pomaz.szeredi.hu>
 <20070618.005711.21897961.davem@davemloft.net> <E1I0CTH-0006k3-00@dorka.pomaz.szeredi.hu>
 <20070618.021813.105401188.davem@davemloft.net> <E1I0DYW-0006uZ-00@dorka.pomaz.szeredi.hu>
 <20070618124721.56411b93@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 18 2007 12:47, Alan Cox wrote:
>
>> Do you want me to send the patch to Andrew instead?  His attitude
>> towards bugfixes is rather better ;)
>
>And it'll get NAKked and binned. DaveM is (as happens sometimes ;)) right
>to insist on the code being clean and efficient.

Or see RFC 1925 number 7a. :)


	Jan
-- 
