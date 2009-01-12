Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZALKgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZALKgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZALKf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:35:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:13235 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbZALKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DdQYXqQe5zmjVStuFTOdbxNW4wQX0+dNEIqRrFpaVxQdJJqI/VipJJ/7f566YA6wG3
         zJZHZA/8cnr0YBQUai7r0cenG738beE+KolhcBa5nzuVtbcTW00cJdcsk/g0MiaVHcVK
         26Le+4NfFXRKRN731+y8ACxGzDhbMsKud5ZkU=
Message-ID: <2f11576a0901120235x3b16ae90y61ef9ba10d743894@mail.gmail.com>
Date: Mon, 12 Jan 2009 19:35:55 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Greg Ungerer" <gerg@snapgear.com>
Subject: Re: [PATCH for 2.6.28 stable] m68knommu: fix m68knommu defconfig can't build
Cc: "David S. Miller" <davem@davemloft.net>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Greg Ungerer" <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
       stable@kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48E9AE16.2000002@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081230193943.1281.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48E9AE16.2000002@snapgear.com>
X-Google-Sender-Auth: b7ae2b0305fb9e35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Kosako,
>
> KOSAKI Motohiro wrote:
>>
>> I guess nobody don't test m68knommu at all last three month.
>> Do we still need to maintain this architecture?
>
> Yes, we do.

ok. I don't have objection.
thank you.
