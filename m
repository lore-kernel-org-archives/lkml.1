Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbXLLLZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbXLLLZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbXLLLZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:25:23 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:9634 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbXLLLZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RwkrjmcNSg/KW2dfV6o0ujMxgqIMu38lu56GzpjIZ9y8CEx4oel3mfGxRjndZII58smx9TyrH9q8Og38zR7UaC/eEUEi/Y16gYz0b1FWQVzLFZ1KFNdQdOfWRjsKz5OHWxL2jmvOyqT60t96wpzyEdtKmXZK1PtLOD3ies6pHTU=
Message-ID: <4af2d03a0712120325n50d057baq7ec440c5e57fda39@mail.gmail.com>
Date: Wed, 12 Dec 2007 12:25:20 +0100
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [RFT] Port 0x80 I/O speed
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz,
       andi@firstfloor.org, rol@as2917.net, "Krzysztof Halasa" <khc@pm.waw.pl>,
       david@davidnewall.com, hpa@zytor.com, john@stoffel.org,
       linux-os@analogic.com
In-Reply-To: <475FA060.6070004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475F1DC6.5090403@keyaccess.nl> <475FA060.6070004@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 9:48 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 12/12/2007 12:31 AM, Rene Herman wrote:
> > Good day.
> >
> > Would some people on x86 (both 32 and 64) be kind enough to compile and
> > run the attached program? This is about testing how long I/O port access

model name      : Intel(R) Xeon(R) CPU           E5335  @ 2.00GHz

cycles: out 3217, in 1898
cycles: out 3217, in 1898
cycles: out 3217, in 1898
cycles: out 3217, in 1898
cycles: out 3217, in 1898
cycles: out 3217, in 1898
cycles: out 3217, in 1898
cycles: out 3217, in 1898
cycles: out 3217, in 1898
cycles: out 3217, in 1898

model name      : Dual Core AMD Opteron(tm) Processor 275
cycles: out 5508, in 5524
cycles: out 5509, in 5525
cycles: out 5510, in 5522
cycles: out 5512, in 5522
cycles: out 5512, in 5522
cycles: out 5510, in 5524
cycles: out 5510, in 5522
cycles: out 5511, in 5525
cycles: out 5513, in 5521
cycles: out 5509, in 5522
