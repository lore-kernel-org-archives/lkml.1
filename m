Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655Ab0A2D4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0A2D4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 22:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637Ab0A2D4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 22:56:10 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:8871 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755052Ab0A2D4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 22:56:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkcBAKjqYUtLd/sX/2dsb2JhbAAIgyvHEJABgSuCPFkE
X-IronPort-AV: E=Sophos;i="4.49,364,1262581200"; 
   d="scan'208";a="54799402"
Message-ID: <4B625C55.1050807@teksavvy.com>
Date: Thu, 28 Jan 2010 22:56:05 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Vishal Rao <vishalrao@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, stable@kernel.org
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>	 <4B5F62C2.4000800@pobox.com> <aacba7e1001261624m4358e4ebwcf8e2305b0c5fc16@mail.gmail.com> <4B60C30D.4040203@teksavvy.com>
In-Reply-To: <4B60C30D.4040203@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>
> Okay, that's ICH9.  I'll see if I have an ICH9 kicking around here
> that I can put an OCZ/Indilinx drive onto.  The current v1.5 OCZ firmware
> is probably pretty close to the 1916 build version that your Crucial has.
..

The best I have is ICH7 and ICH8.
My OCZ/Indilinx drives all work without any issues in NCQ on those systems,
using the latest OCZ firmware -- similar vintage to your broken Crucial drive.

Cheers

