Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZKES0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZKES0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbZKES0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:26:42 -0500
Received: from mail175c2.megamailservers.com ([69.49.111.75]:40548 "EHLO
	mail175c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758209AbZKES0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:26:41 -0500
X-Greylist: delayed 13157 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2009 13:26:41 EST
X-Authenticated-User: kristoffer.gaisler.com
Message-ID: <4AF2E4D0.2010006@gaisler.com>
Date: Thu, 05 Nov 2009 15:44:32 +0100
From: Kristoffer Glembo <kristoffer@gaisler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070601 SeaMonkey/1.1.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build failure
References: <20091105185014.76dd0d31.sfr@canb.auug.org.au>	<20091104.235315.18303666.davem@davemloft.net> <20091105.000012.61292273.davem@davemloft.net>
In-Reply-To: <20091105.000012.61292273.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> 
> Hmm, it took a tiny bit more than that :-)  Here's what I commited
> to fix this, thanks.
> 
> apbuart: Kill dependency on deprecated Sparc-only PROM interfaces.
> 
> Use the proper modern OF ones instead.
> 
> Noticed by Stephen Rothwell.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks guys. Sorry for the obsolete code :-)

Best regards,
Kristoffer
