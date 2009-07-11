Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZGKIdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZGKIdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZGKIdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:33:43 -0400
Received: from mail-bw0-f212.google.com ([209.85.218.212]:62517 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZGKIdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=k0ZXedcNa8wdNVDhGs/+7fembUp1QamNuSrLNcTc1/dSbdHcK9Z0wAJ1g21aQ205re
         dbATQ3WRa2XVKYdy0/VFaHYd0l7hUJbSno2q6S4TJkNZZfb6NJlTT/t6n9FWeM7/5f3X
         OlazX03WOfjkUfg1DOk1JhKKc9Fhqv4CKsMsg=
Message-ID: <4A584E62.6050500@gmail.com>
Date: Sat, 11 Jul 2009 10:33:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5, revised] staging/otus: Drop an unnecessary NULL test
References: <Pine.LNX.4.64.0907111031480.29592@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907111031480.29592@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2009 10:32 AM, Julia Lawall wrote:
> Apparently, the NULL test is not necessary at this point.
> 
> The semantic patch that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Jiri Slaby <jirislaby@gmail.com>
