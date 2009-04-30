Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbZD3FLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbZD3FLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 01:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZD3FKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 01:10:55 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:40935 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZD3FKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 01:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qp2JxKjOq7CiIjebV1DpyCyLT3KYy2a6PspGe6NZ4yFsGjSHtPZ1eB5aucjEfVQy8H
         Z2dXu7Yitr7PrKbLdl6nfYNAAMFPke2Usbbwv8f7NNa5H8HXbk/IxSQFbRasS36xovG4
         P7zxgiQseptFfiZAC6uxwlVw0k8W9V1fWKXT4=
MIME-Version: 1.0
In-Reply-To: <20090428.043929.171852977.davem@davemloft.net>
References: <2a27d3730904280316l7049bddbie914907b16ccfff6@mail.gmail.com>
	 <1240913737-23773-1-git-send-email-leoli@freescale.com>
	 <20090428.043929.171852977.davem@davemloft.net>
Date: Thu, 30 Apr 2009 13:10:53 +0800
X-Google-Sender-Auth: 968ec8fec8cc8a21
Message-ID: <2a27d3730904292210q67e18274nf6676a054b780639@mail.gmail.com>
Subject: Re: [PATCH] rapidio: add common mapping APIs for RapidIO memory 
	access
From: Li Yang <leoli@freescale.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, galak@kernel.crashing.org,
       mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org, zw@zh-kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 7:39 PM, David Miller <davem@davemloft.net> wrote:
>
> Please number your patches. :-/
>
> There is no way for anyone to be able to tell in what order
> your changes should be applied.

Sorry for that.  I thought I have added -n when doing the
git-format-patch, but it turns out not the case. :(  Will double check
next time.

- Leo
