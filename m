Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZBQEHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZBQEHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 23:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZBQEHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 23:07:46 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:37757 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZBQEHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 23:07:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LwpRHSK1E6FUQ/+S5UlezfpJ7VZNgq3BxFuMLJEsc6IZhT/XyYuqSI5LUHKl0Ri2ui
         YTPRdXgckGy1Yq+WUrAeIUlKPd3Hd2JOHbhswQbdxP3S0CYLwrz3FhUifDQF1e6IWjsx
         924/U9YKKSbcYq4YH3C1zgg3kECPa2rc/LQXs=
MIME-Version: 1.0
In-Reply-To: <20090217031926.GE8343@kroah.com>
References: <1233319715-4877-1-git-send-email-tom.leiming@gmail.com>
	 <20090130065224.47729f41@infradead.org>
	 <20090204230851.GF18484@kroah.com>
	 <20090204170858.2d07b546@infradead.org>
	 <20090205180856.GA20805@kroah.com>
	 <d82e647a0902161714y46ac2785lbd0bd964902289e5@mail.gmail.com>
	 <20090217031926.GE8343@kroah.com>
Date: Tue, 17 Feb 2009 12:07:44 +0800
Message-ID: <d82e647a0902162007k3ba092dco37117ce838fec898@mail.gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v3)
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Arjan van de Ven <arjan@infradead.org>, kay.sievers@vrfy.org,
       cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/17 Greg KH <greg@kroah.com>:
> On Tue, Feb 17, 2009 at 09:14:34AM +0800, Ming Lei wrote:
>> Hi, Greg
>> Would you mind queuing this patch into your tree?
>
> What patch?  Did anyone resend it to me like I asked?

I mean the patch in the mail list,with the following subject:

         [PATCH] driver core: remove polling for driver_probe_done(v3)

Thanks!

>
> confused,
>
> greg k-h
>



-- 
Lei Ming
