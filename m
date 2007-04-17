Return-Path: <linux-kernel-owner+w=401wt.eu-S1161379AbXDQS2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161379AbXDQS2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161375AbXDQS2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:28:37 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:29202 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161371AbXDQS2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:28:36 -0400
X-IronPort-AV: i="4.14,419,1170651600"; 
   d="scan'208"; a="27538777:sNHT22107316"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Aubrey Li" <aubreylee@gmail.com>, "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU
Date: Tue, 17 Apr 2007 14:30:20 -0400
User-Agent: KMail/1.9.5
Cc: uaca@alumni.uv.es, bryan.wu@analog.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, waltje@uwalt.nl.mugnet.org,
       netdev@vger.kernel.org, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <200704091146.32346.rgetz@blackfin.uclinux.org> <200704101952.05380.rgetz@blackfin.uclinux.org> <6d6a94c50704170336l62fc9ael1e58197e6c3853ba@mail.gmail.com>
In-Reply-To: <6d6a94c50704170336l62fc9ael1e58197e6c3853ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704171430.21075.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Apr 2007 18:28:30.0342 (UTC) FILETIME=[32BA4A60:01C7811E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17 Apr 2007 06:36, Aubrey Li pondered:
> Here, in the attachment I wrote a small test app. Please correct if
> there is anything wrong, and feel free to improve it.

Thanks. 

David - Does this give you what you need?
