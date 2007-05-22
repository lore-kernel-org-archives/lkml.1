Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbXEVU3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbXEVU3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbXEVU27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:28:59 -0400
Received: from smtp3.wanadoo.co.uk ([193.252.22.156]:49325 "EHLO
	smtp3.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbXEVU27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:28:59 -0400
X-ME-UUID: 20070522202856444.6C8001C00087@mwinf3206.me.freeserve.com
Message-ID: <46535287.7060904@cjsoftuk.dyndns.org>
Date: Tue, 22 May 2007 21:28:55 +0100
From: Chris Malton <chrism@cjsoftuk.dyndns.org>
Organization: CJSoft UK
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NCPFS can't handle extended characters.
References: <4652E735.7000206@cjsoftuk.dyndns.org> <20070522205723.0d0dc5ce@the-village.bc.nu>
In-Reply-To: <20070522205723.0d0dc5ce@the-village.bc.nu>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms030902000506030803060700"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms030902000506030803060700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Cox wrote:
> For any real hope to answer things like that it would be useful to have
> precise descriptions of what fails, any messages logged when it occurs
> etc.

OK,

What fails: A dir on the folder containing the offending file results in 
part listings or no listing at all.

There are no messages logged anywhere, dir completes successfully 
without complaining.  I'm going to recompile with the latest kernel and 
debug in a few weeks time (add the debug option to the NCPFS kernel module).

On this occasion the offending files had a character produced by MS Word 
in them.  I can't find out which charcode at present (think it was 
charcode 180).

Chris

> 
> Alan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


--------------ms030902000506030803060700
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
--------------ms030902000506030803060700--

