Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0BYEDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:03:35 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:34169 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab0BYEDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:03:32 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
Date: Thu, 25 Feb 2010 05:03:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Yuhong Bao <yuhongbao_386@hotmail.com>, hancockrwd@gmail.com,
       david-b@pacbell.net, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <4B7CAF95.6020306@gmail.com> <SNT125-W36AFF0BF953EABAC9A0432C3400@phx.gbl> <4B85EE88.5050506@kernel.org>
In-Reply-To: <4B85EE88.5050506@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002250503.09327.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 25. Februar 2010 04:29:12 schrieb Tejun Heo:
> Arghhh.... I hate when intel pulls this type of 'product
> differentiation' stunts.  At any rate, I'm doubtful swiotlb'ing for
> usb2.0 would be noticeable at all.

That can and should be tested.

	Regards
		Oliver
