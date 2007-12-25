Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbXLYXpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbXLYXpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXLYXp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:45:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXLYXp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:45:27 -0500
Message-ID: <47719611.6030502@zytor.com>
Date: Tue, 25 Dec 2007 15:45:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][DOC] Console is utf-8 by default
References: <20071225231144.GA4061@implementation>
In-Reply-To: <20071225231144.GA4061@implementation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault wrote:
> The console is now by default in UTF-8 mode, so let's document this.
> BTW, document the needed "vt." prefix.
> 
> -	vt.default_blu=	[VT]
> +	default_blu=	[VT]

Reverse patch?

	-hpa
