Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYJ1N7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYJ1N7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYJ1N7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:59:24 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:54541 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYJ1N7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:59:23 -0400
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Message-Id: <4C301539-D8EE-4E76-8E33-FF6493E311F7@freescale.com>
From: Kumar Gala <kumar.gala@freescale.com>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
In-Reply-To: <20081013045116.GA11637@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] powerpc: enable heap randomization for linkstations
Date: Tue, 28 Oct 2008 08:58:48 -0500
References: <20081013040703.GA11059@ime.usp.br> <20081013045116.GA11637@ime.usp.br>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2008, at 11:51 PM, Rogério Brito wrote:

> The current defconfig for Linkstation/Kuroboxes has the "Disable Heap
> Randomization" option enabled.
>
> Since some of these machines are facing the internet, it helps to have
> heap randomization enabled. This patch enables it.
>
>
> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
>
> ---


applied to merge.

- k