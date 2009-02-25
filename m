Return-Path: <linux-kernel-owner+w=401wt.eu-S1761753AbZBYP4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753AbZBYP4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZBYP4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:56:33 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:57747 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbZBYP4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:56:32 -0500
Message-ID: <49A56A2B.4040305@f-seidel.de>
Date: Wed, 25 Feb 2009 16:56:27 +0100
From: Frank Seidel <frank@f-seidel.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
       lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
Subject: Re: [PATCHv3][trivial] crypto: tcrypt - reduce stack size
References: <49A54C23.8090209@suse.de> <49A5549F.4070304@suse.de> <49A55B5A.70705@suse.de> <alpine.LRH.2.00.0902251604430.15476@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0902251604430.15476@vixen.sonytel.be>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> BTW, why are you using printk(KERN_INFO "..."), and not pr_info("...")?

Without special reason. Is pr_info preferred?

Thanks,
Frank
