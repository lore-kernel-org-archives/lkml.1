Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZALL27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZALL27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZALL2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:28:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:50259 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZALL2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qGERPG+/Frct6FPEMEwUZffFdPlzPPt6X1L69kaVnxk3/u+ZunRMjjPKNG0iqre7Ld
         JgBaW7xVqO2AA/E011UR3mCUmlDZ04hqpxxsrG8vbyN6atoYBasLTE/lz6aKHN8zLYZl
         7JzFxuM+spa2KQDfilezmNR9WFizZCxmkKx+k=
Message-ID: <8db1092f0901120328x77326d4ex9a4ee879416d34a7@mail.gmail.com>
Date: Mon, 12 Jan 2009 12:28:47 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.29-rc1 does not boot
Cc: "Dieter Ries" <clip2@gmx.de>, travis@sgi.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090112112608.GB19388@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu>
	 <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu>
	 <496A3F62.8090902@gmx.de>
	 <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com>
	 <20090112112608.GB19388@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/12 Ingo Molnar <mingo@elte.hu>:

> yes - the revert patch can be found below.

I will test it in this evening.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
