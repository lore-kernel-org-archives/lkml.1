Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZCNEnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZCNEnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 00:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZCNEni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 00:43:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:65530 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCNEnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 00:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tc0+NKNx3RBQNesHTgMq8+0ODms/5Ghu50+CWALCkw9bQ2pxa5faxg0Nq7Unnu2qja
         HFqv9TyIG7eIe77r9Ot98gF1+27nn/nF7MCxFnaMsVyEUDb/yeRgRK3QQvH75ac/qW3K
         2K8kfFlB9gnT6JXFpdypLZPpm3/6a346BTYJQ=
MIME-Version: 1.0
In-Reply-To: <200903140040.18740.gene.heskett@gmail.com>
References: <200903131642.54925.gene.heskett@gmail.com>
	 <49BB172D.5060609@gmail.com>
	 <86802c440903132126w3738533dn8db7302f202dc4be@mail.gmail.com>
	 <200903140040.18740.gene.heskett@gmail.com>
Date: Fri, 13 Mar 2009 21:43:35 -0700
X-Google-Sender-Auth: fb7c2a8313390c40
Message-ID: <86802c440903132143m687a56b2h2f0fce2edc8af420@mail.gmail.com>
Subject: Re: New ASUS 1701 bios for M2N SLI DELUXE
From: Yinghai Lu <yinghai@kernel.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Robin.Laing@drdc-rddc.gc.ca,
       LKML <linux-kernel@vger.kernel.org>,
       David Newall <davidn@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 9:40 PM, Gene Heskett <gene.heskett@gmail.com> wrote:
>>
>>what is nic? could be put in D3 somehow.
>>
> The nic's (2 of them) are in the motherboards MCP55 chipset according to what
> I have been told.

forcedeth already has D3hot workaround. so could other problem

YH
