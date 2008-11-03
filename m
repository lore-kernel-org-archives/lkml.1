Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYKCTBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYKCTBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYKCTB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:01:27 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:34657 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbYKCTB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CuWxS+lNQqEisEVFkdx7J/tt/I43Lhop7Hxdm2oLalhghJZ5VyPrvSPe3VWn75rcrT
         ivz9skMCGlOk3zEQi2ldxUitApaSxJod7ABXhNhltDRHXQ2AYHOCR6Hu6pej9lQ13wY2
         p9LJYTzTH5WqpuIgvdHkJfRI8lYWYUBZrPtqQ=
Message-ID: <8db1092f0811031101t48d3fa3btd35ac7eb46ee1ef@mail.gmail.com>
Date: Mon, 3 Nov 2008 20:01:25 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Alexey Starikovskiy" <aystarik@gmail.com>
Subject: Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Robert Hancock" <hancockr@shaw.ca>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "fabio.comolli@gmail.com" <fabio.comolli@gmail.com>
In-Reply-To: <8db1092f0811030837i4ccf0b7vc0c14e846f83d88f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.1HaqObZirROiyqr922A7hRDVc54@ifi.uio.no>
	 <49035313.9080309@shaw.ca> <200810252004.01274.rjw@sisk.pl>
	 <8db1092f0810251151l4c7f9382r34defa6d4d6ee24c@mail.gmail.com>
	 <8db1092f0810271319s5d15c2ffrab37a548fa388738@mail.gmail.com>
	 <1225187050.5189.146.camel@yakui_zhao.sh.intel.com>
	 <8db1092f0810281245k14555e26w30547cf17fde534f@mail.gmail.com>
	 <8db1092f0811030406i48150022gb5b444710d749b43@mail.gmail.com>
	 <490EEDDD.4010203@gmail.com>
	 <8db1092f0811030837i4ccf0b7vc0c14e846f83d88f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/3 Maciej Rutecki <maciej.rutecki@gmail.com>:

> Patch from comment #3 doesn't help. I will try patches from #11896 very soon.
>

Booth patches (from comment #1-4 and 6) work OK

Thanks for help
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
