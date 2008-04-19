Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbYDSKWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbYDSKWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYDSKW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:22:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:62522 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYDSKWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ki4YY/jfcGfjoKL0R8z6aSJsS8BS8r0cE+aWoqReKWnpf9TJzULFrHW1HO5lK58lS37xE/thI24q07ee82J6BOpPC9tqo2JiffXP1/eT1iX1gkxl4zFSiTcMpUpLkuVa0foV1lgt7ui1JzXBClqMRye8nhMSu2nQHvLiVvGsqcA=
Message-ID: <e85b9d30804190322o703d3b20se22eb6b5e82bae39@mail.gmail.com>
Date: Sat, 19 Apr 2008 12:22:14 +0200
From: Matthew <jackdachef@gmail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Linux 2.6.25
Cc: torvalds@linux-foundation.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Gene Heskett" <gene.heskett@gmail.com>, "Len Brown" <lenb@kernel.org>
In-Reply-To: <e85b9d30804190318u74e14f0ct6ab53cb86f6ce15f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
	 <alpine.LFD.1.00.0804180843150.2879@woody.linux-foundation.org>
	 <20080418193802.GK7674@cvg> <20080418200338.GL7674@cvg>
	 <48096179.4060803@keyaccess.nl> <480964F7.3040701@keyaccess.nl>
	 <20080419061701.GA7688@cvg>
	 <e85b9d30804190318u74e14f0ct6ab53cb86f6ce15f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The coretemp kernel module reports 25°C on my PC when idle, and 34°C
>after having performed some computations (lmbench2). This looks
>normal. This test has been performed with a vanilla 2.6.25 kernel and
>a Core 2 Duo E6750 CPU (Asus motherboard). The 2.6.22 and 2.6.24
>kernels report an incorrect temperature on the same system however
>(10°C). So there is either an issue with the patches that have been
>applied to your kernel or the behavior of the coretemp module for the
>6600 and E6750 CPU's is different. Can you repeat the test with a
>vanilla 2.6.25 kernel ?

>(Added Rudolf Marek in CC, the coretemp author.)

>Bart.

sure, I'll test-drive the vanilla-kernel, too

thanks

Mat
