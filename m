Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbXB0O1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbXB0O1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXB0O1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:27:11 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:36846 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbXB0O1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:27:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jsUnu1KyvMIi8pfreFKtcHisOc7WBMBloc0PaNBgaDBTqjuC1Btbs7jJ6HGs8/oMlTFbOPMq3jQF3fhNtpyuyn/ZD6wFhRq6Q4Ph/K27x6qgpv6mhhsWrv94ICYl03JKdDZz4w9qr3zaHMev2+zoc1aPpFIrxWhCZ50MP/GcXF0=
Message-ID: <1defaf580702270627j756631afi1094c11b25294def@mail.gmail.com>
Date: Tue, 27 Feb 2007 15:27:07 +0100
From: "Haavard Skinnemoen" <hskinnemoen@gmail.com>
To: "Kyle McMartin" <kyle@mcmartin.ca>
Subject: Re: ioread32 endianess.
Cc: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070227135535.GD3545@athena.road.mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f19298770702260736i51622584r1979a202bdc64c1d@mail.gmail.com>
	 <20070226160450.GB3787@athena.road.mcmartin.ca>
	 <f19298770702270431i198e032fhe025e221a625140f@mail.gmail.com>
	 <20070227132021.GC3545@athena.road.mcmartin.ca>
	 <20070227135535.GD3545@athena.road.mcmartin.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Kyle McMartin <kyle@mcmartin.ca> wrote:
> __raw_(read|write){b,w,l} are also old style accessors. They always operate
> in host endianness.

Are there any "new style" accessors operating in host endianness?

Haavard
