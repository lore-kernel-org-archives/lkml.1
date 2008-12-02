Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYLBSGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYLBSGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYLBSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:06:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:8907 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbYLBSGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:06:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=yHVYIYJx8yWwGvnXgyCQ7ONM7/Eh5qwl6PbhKDcG96fLOC3VcWbzWhX1fsIuf5Rn0O
         IwlZcBh2lvfpS0DpEn3w7yC+KJXzT3RDjTUGkzSLrJpdr63cIkeeGsSl7wsigf8pWd2Q
         KWPPKnnDKNgY2ZhUdfnn+ARhdoxf1HIfInFgI=
Date: Tue, 2 Dec 2008 19:06:17 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Michael B. Trausch" <mike@trausch.us>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, pazke@ports.donpac.ru
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202190617.61b61592@varda>
In-Reply-To: <20081202121111.245d2ecc@zest.spicerack.trausch.us>
References: <fa.IDjfwzrT2B02+NHfmYwtICnzOOA@ifi.uio.no>
	<fa.J8MFTCUT8El3sK8BuYDBvaMRaB8@ifi.uio.no>
	<fa.q/4H3AtoJGSJ+i8tlXR4X35LFFU@ifi.uio.no>
	<fa.98CeSgxJ/GGaLLyZ97s1oHgh7hE@ifi.uio.no>
	<20081202121111.245d2ecc@zest.spicerack.trausch.us>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 2 Dec 2008 12:11:11 -0500
"Michael B. Trausch" <mike@trausch.us> escribió:

[...]
> 
> Alejandro, can you switch back to VTs again after rebuilding your
> NVIDIA module?
 
  I can switch to VT's and the bug still manifest 2.6.28-rc7
  

>  Also, you seem to have mentioned that you're not using
> Ubuntu's packaged NVIDIA driver... this may mean that you've
> overwritten and/or moved other files that Ubuntu uses, since the NVIDIA
> driver installer does this automatically.

  I'm using the nvidia installer for the 180.06 driver yes

> Can you try using a stock
> system, updated kernel, and let DKMS build the NVIDIA module?  You'll
> need to make some alterations, but I can help with those.

 Would the nvidia.com uninstaller leave things as in a stock install?
 Where can i find help about DKMS? also does it work if you use the
 "vanilla way" of installing kernels? i do:
  make ; make install ; make modules_install ; and mkinitramfs to install
  kernels i test
 

> 
> 	HTH,
> 	Mike
> 
