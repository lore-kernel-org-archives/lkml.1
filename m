Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbZBYQCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbZBYQCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbZBYQCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:02:12 -0500
Received: from ns1.suse.de ([195.135.220.2]:53342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZBYQCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:02:11 -0500
Message-ID: <49A56B6E.9090600@suse.de>
Date: Wed, 25 Feb 2009 17:01:50 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Frank Seidel <frank@f-seidel.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
       lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
Subject: Re: [PATCHv3][trivial] crypto: tcrypt - reduce stack size
References: <49A54C23.8090209@suse.de> <49A5549F.4070304@suse.de> <49A55B5A.70705@suse.de> <alpine.LRH.2.00.0902251604430.15476@vixen.sonytel.be> <49A56A2B.4040305@f-seidel.de> <alpine.LRH.2.00.0902251657431.15476@vixen.sonytel.be>
In-Reply-To: <alpine.LRH.2.00.0902251657431.15476@vixen.sonytel.be>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> It's shorter.
> 
> Especially `pr_err' fits in the space of `printk', so you don't have to split
> lines that become to long due to adding the KERN_*.

Ah, i see. Thanks for the explanation :-)

Frank

