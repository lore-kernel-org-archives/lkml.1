Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbXLLOtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbXLLOtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXLLOs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:48:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:52638 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbXLLOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:48:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wg9TgUd9DOpZ6wLXyv0NIeLpFwxQfLDq5o7ExUlI6+9scgHL4QL/8kl2LKqbtTzqjFQMDOdm4cBWkNjxRhiesu7A3c7d9gco0ZT75u8KT9/+GLiqKPJ1mQZNiYtCtZ3sz7zuqpWMByxIIxR3rfqhrleLkthrM8FUg+rZp/+8PaA=
Message-ID: <b25c3fa70712120648l23572f7cm51fb24f881c8f31b@mail.gmail.com>
Date: Wed, 12 Dec 2007 23:48:52 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: subrata@linux.vnet.ibm.com
Subject: Re: [PATCH 7/7] [NETDEV]: myri10ge Fix possible causing oops of net_rx_action
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       help@myri.com
In-Reply-To: <1197448257.4710.31.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <002801c83c73$af10f990$9c94fea9@jason>
	 <1197448257.4710.31.camel@subratamodak.linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/12, Subrata Modak <subrata@linux.vnet.ibm.com>:
> Would you like to submit the Driver Test Cases to LTP ? Or, if you have
> your Driver test cases written in C, we can port to LTP and have it
> inside the LTP package.
> You can also check out the following links for more info, and can always
> ping me for anything:
> http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/kernel/device-drivers/,
> http://ltp.sourceforge.net/documentation/how-to/ltp.php?
>
> Regards--
> Subrata
> (LTP Maintainer)
>

Subrata,
I can't sure it's possible since my test was needed some hardware
stuffs but I'll try it in near future and contact you.

Thanks.
Joonwoo
