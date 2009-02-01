Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbZBAO1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbZBAO1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 09:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZBAO1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 09:27:37 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:50057 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbZBAO1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 09:27:36 -0500
Date: Sun, 1 Feb 2009 15:24:35 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28 + Trust 610 LCD PowerC@m Zoom, webcam mode?
Message-ID: <20090201152435.0e06e42e@free.fr>
In-Reply-To: <49856A54.1020105@freemail.hu>
References: <49856A54.1020105@freemail.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Feb 2009 10:24:36 +0100
Németh Márton <nm127@freemail.hu> wrote:
> Hello Jean-Francois,

Hello Márton,

> I have a Trust 610 LCD PowerC@m Zoom camera which can operate in
> webcam mode also (USB ID=06d6:0031). I tried to use it together with
> Linux 2.6.28 and with xawtv-3.95.dfsg.1 and with gqcam 0.9.1.
> The /dev/video0 appeared, but no usable picture was visible.
> 
> However, I downloaded
> http://mxhaard.free.fr/spca50x/Download/gspcav1-20071224.tar.gz and
	[snip]
> Do you have any idea why the gspcav1 diver is working and the one
> which is included in Linux 2.6.28 not?

The gspcav1 is not maintained anymore.

It seems that your webcam has not been tested with gspcav2.

First, did you use the v4l library and its wrapper when running xawtv
and gqcam?

Then, have you tried my program svv?

If nothing works, please, send me the kernel traces and the image.dat as
indicated in the gspca_README.txt of my page.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
