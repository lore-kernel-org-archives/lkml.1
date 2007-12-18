Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbXLRGJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbXLRGJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 01:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXLRGJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 01:09:11 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:5814 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbXLRGJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 01:09:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vbStndE8cvPmrex4adz3E6kVWhHJlpuDGor042H9kvNh3rmKiOnIi1+a7Kl5fAl/btNxo9uVA6wVNtEbGL0zL0UHMte81TktCgID2zqOaUotZhFxDgJvgYEEjdHSgkQPv85ea5nBBnvUk9XM4qRdX88qP5o61F1JUl/ShZ09GOw=
Message-ID: <82e4877d0712172209leabf6c7nf88ac19fdb4b347e@mail.gmail.com>
Date: Tue, 18 Dec 2007 01:09:08 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: init_timer_deferrable conversion
Cc: linux-kernel@vger.kernel.org, "David Miller" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <20071217152943.10470215.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712162149220.4622@mini.warudkars.net>
	 <20071217095504.b02241ee.dada1@cosmosbay.com>
	 <20071217152943.10470215.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 9:29 AM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Parag, could you please try this patch ?
>
> [NET] ARP : Convert neigh garbage collection from softirq to workqueue
>

I will - a little later.

Thanks

Parag
