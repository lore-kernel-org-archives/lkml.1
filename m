Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYGWNQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYGWNQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYGWNQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:16:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:51508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYGWNQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LrOO3k8E2h3AJRaKDGSk2AfKqSRNRu62msW1pb1RaF9MxzU/6s13QrXiRr45j2knfM
         Hbap5B3PH4yYNUvqeVNeeB7UbqLCYBXJTAOCVEOPRcA6smsj+2b8c5QqZ1DR8hr7STnE
         FCxPkDXr/yaDpf9vhcns8pf237vaB4FpMaPM0=
Message-ID: <5a4c581d0807230616n5a8e7ecfm172cfe0bd8d11b7e@mail.gmail.com>
Date: Wed, 23 Jul 2008 15:16:05 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Alessandro Guido" <ag@alessandroguido.name>
Subject: Re: [BUG] kernel BUG at net/core/dev.c:1328!
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <d4b984a30807230057t319eca71g32262305bdb07582@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d4b984a30807210914nd4d0db5yb7b93ca5143ff0d5@mail.gmail.com>
	 <20080721.092027.14394005.davem@davemloft.net>
	 <d4b984a30807220254t1aaf6ac4q874329966511b0c5@mail.gmail.com>
	 <20080722.155611.176476925.davem@davemloft.net>
	 <d4b984a30807230057t319eca71g32262305bdb07582@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 9:57 AM, Alessandro Guido
<ag@alessandroguido.name> wrote:
> I'm testing the latest Linus' git which includes your patch
> (2.6.26-06077-gc010b2f) and the problem is fixed.
>
> Thank you!

-git10 also has this fixed for me. Thanks,

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
