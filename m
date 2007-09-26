Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXIZOTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXIZOTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbXIZOTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:19:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:10431 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbXIZOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:19:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=dgeZzI3oizrBZj1dpBinmu37VJ82DoN+eyszDwi26KWjgxcqvDmD+9c74uasV5OAdFG9p+ZBOXIyxChmxeI5C9a5t4PLfN5D7o1roaIJZn8gCerWqIrqW3XoZbzPt4nqfuD/VVt1IeWN6UQqvbPkFysT8tTW0OCM2Qf6WCftYgo=
Message-ID: <46FA6A60.2000700@gmail.com>
Date: Wed, 26 Sep 2007 08:19:12 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F9E2CB.9000002@garzik.org>
In-Reply-To: <46F9E2CB.9000002@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------060406000509040009080407"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060406000509040009080407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> Would it also be possible for you to send along 'hdparm --Istdout'
> output for your config disk thingy, /dev/sdd ?

Sure, just don't ask me what it is!  (I've generally assumed that
writing to it would be a bad idea.)

Berck

--------------060406000509040009080407
Content-Type: text/plain;
 name="hdparmthingy"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hdparmthingy"


/dev/sdd:
0040 3fff c837 0010 0000 0000 003f 0000
0000 0000 3030 3030 3030 315f 5f5f 5f5f
5f5f 5f5f 5f30 5f45 0003 3e00 0004 5247
4c31 3033 3634 436f 6e66 6967 2020 4469
736b 2020 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 8001
0000 2f00 4000 0200 0000 0007 3fff 0010
003f fc10 00fb 0101 0280 0000 0000 0407
0003 0078 0078 0078 0078 0000 0000 0000
0000 0000 0000 0000 0201 0000 0000 0000
007e 001b 0068 5060 4000 0000 1000 4000
407f 0000 0000 0000 fffe 0000 c0fe 0000
0000 0000 0000 0000 0002 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0001 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0017 2040
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 b4a5

--------------060406000509040009080407--
