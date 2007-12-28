Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbXL1DKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbXL1DKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 22:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbXL1DKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 22:10:22 -0500
Received: from psyche.piasta.pl ([83.175.144.5]:51711 "EHLO psyche.piasta.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbXL1DKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 22:10:21 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2007 22:10:21 EST
Date: Fri, 28 Dec 2007 04:03:45 +0100
From: Marek Kierdelewicz <marek@piasta.pl>
To: Gustavo Guillermo =?ISO-8859-2?Q?P=E9rez?= 
	<gustavo@compunauta.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Corrupted Hard Drive after activating intel I/oat dma
Message-ID: <20071228040345.67db1361@catlap>
In-Reply-To: <200712271949.02116.gustavo@compunauta.com>
References: <200712271949.02116.gustavo@compunauta.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

>By mistake we activate intel I/oat dma support on a laptop with a
>centrino duo to try to get better performance on IO.

I/OAT is for accelerating network operations on newer Xeon processors
and E1000 nics. Some information about it is available here:
http://lwn.net/Articles/165131/

There's no way that enabling this option could cause your hdd to fry.

>know the option was not supported, but I want to know if cause that we
>can have a fried hd :(.
>thanks in advance if someone has something to said about the
>failure. :(
>Kernel 2.6.19-gentoo-r7

I'm a gentoo@laptop user myself. This distro is very disk-demanding
because of the frequent compilations. In my opinion it's not the best
distro for a mobile system. No wonder your disk gave out :(.

Cheers,
Marek Kierdelewicz
KoBa ISP
