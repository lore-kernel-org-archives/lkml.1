Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbXAXPxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbXAXPxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXAXPxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:53:22 -0500
Received: from web52908.mail.yahoo.com ([206.190.49.18]:37114 "HELO
	web52908.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751553AbXAXPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:53:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=jtPEbhxkh0Cep2xZfPHTu5neCw3ZifuRCWzbAKyA6XoNOd4Rh6tPg8PR5f8ZIA0pB7c2ZPvpdFgP3ggehoFAfaTTbEJM5OfzcoeddMt1LvYkAYgAsn2nX34SzCaminJXdVyUVOR6eEijJau7Lhr/8MDj7sHo6Z+EY5SiiW1ySTg=;
X-YMail-OSG: kSVQKVEVM1n.NTXTKjwFdSL.W2kGywqMkTXdzATl6f8VGSsdliXGDCIjKiXHAG5URwn1vRsDggf49UkwqMM24GFhkWdALzNJKjb229GMl8j2bOevIZhuDKOa2aWKQB_hGBBZd6Ux2f2tFp2OCZ7RPZsoDVhuAJZx2P5o.rmi70fXQjlarkKz46Z5oT.W
Date: Wed, 24 Jan 2007 15:53:19 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.18-stable release plans?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <964414.64865.qm@web52908.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > But MY kernel is clearly untainted.
> > So what other explanation is there apart from a kernel bug?

> If it's me you're asking: I don't know (overheating, cosmic rays, ...)

I suppose what I'm *really* asking is what the basis is for assuming that this *isn't* a kernel
bug and can therefore be safely ignored, seeing as the oops is real, the hardware is fine and the
kernel is untainted? That seems to cover the bases from where I'm sitting.

Cheers,
Chris

P.S. No micro-heatwaves have occurred here, either. Do we all need to install muon detectors in
our homes before reporting bugs now, so that we can exclude cosmic ray events too?


		
___________________________________________________________ 
To help you stay safe and secure online, we've developed the all new Yahoo! Security Centre. http://uk.security.yahoo.com
