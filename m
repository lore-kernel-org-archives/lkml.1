Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbXIYWrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbXIYWrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXIYWrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:47:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:64881 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbXIYWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=Tp6S3m496GyPceKi1cv8SF5Fj702JjdX/NCzPkn78bk23SpTDKmyTi+gEbzNDc4S4LOhZN+/qGOOfffmLl/SRbxBxc1CEWTg/DPXdRMyQXwcRRTlXd1nTi7RrESHvvABr0qu0S/kZ2QdAcBgv3/dOGl9Iuxda5PAal16WO41pqM=
Message-ID: <46F98FDC.8030508@gmail.com>
Date: Tue, 25 Sep 2007 16:46:52 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org> <46F9617F.1010508@gmail.com> <46F97257.3020502@garzik.org> <46F9869D.60401@gmail.com>
In-Reply-To: <46F9869D.60401@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------090508090309000304080309"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090508090309000304080309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Berck E. Nash wrote:
> hdparm output attached.

Whoops, it really is this time.


--------------090508090309000304080309
Content-Type: text/plain;
 name="hdparm"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hdparm"


/dev/sde:
427a 3fff 0000 0010 e100 0258 003f 0000
0000 000e 5744 2d57 4d41 4b48 3131 3235
3131 3700 0000 0000 0003 4000 004a 3331
2e30 3846 3331 5744 4320 5744 3336 3047
442d 3030 464c 4132 2020 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 8010
0000 2f00 4001 0280 0000 0007 3fff 0010
003f fc10 00fb 0110 44e0 044f 0000 0007
0003 0078 0078 0078 0078 0000 0000 0000
0000 0000 0000 001f 0202 0000 0000 0000
007e 0000 74eb 7f63 4003 74e9 3e43 4003
407f 0000 0000 0000 0000 0000 80fe 0000
0000 0000 0000 0000 44e0 044f 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0001 0141 0000 0000 0000 0746 0000 0000
0000 0000 0000 0000 0000 0000 0002 0001
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 001f
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 001f 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 8da5

--------------090508090309000304080309--
