Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478Ab0AFIcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0AFIcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 03:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337Ab0AFIca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 03:32:30 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:58525 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857Ab0AFIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 03:32:29 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: Robert Hancock <hancockrwd@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Memory probing fails after 2.6.30 (bisected)
In-reply-to: <4B43DF97.7080208@gmail.com>
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org> <4B43DF97.7080208@gmail.com>
Comments: In-reply-to Robert Hancock <hancockrwd@gmail.com>
   message dated "Tue, 05 Jan 2010 18:55:51 -0600."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 06 Jan 2010 09:32:14 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20100106083214.DAAA933C5F5@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.238.172
X-Scan-Result: No virus found in message 1NSRJa-00033J-5L.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1NSRJa-00033J-5L a5ac8fa16fd867ab2211d925e95d31be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hancockrwd@gmail.com said:
> Think you missed posting which was the actual bad commit it reported?

The last one in the list:
8ecee4620e76aae418bfa0e8cc830e92cb559bbb

That's a merge commit. How do i dig futher into that? My git-fu is lacking...

