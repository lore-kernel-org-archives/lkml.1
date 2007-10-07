Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbXJGSzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbXJGSzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 14:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXJGSzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 14:55:36 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:65160 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbXJGSzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 14:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XJgab+61r4VpMsKSKrqCR8L6H1s6gPzd8qUP2qUq3BLDRIxKxDrxfr9O1Lq0creMxX0X06aj9EDHlWeORTGG9t4cIIrtngpdnMnhLd9UNJVIzo/mxs5BPWBl7nMBcCj6vxFQh6HBEHB+5OOcJ5OQEb9eRX93IF49qATDXM2O1Z8=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] Fix Oops in toshiba_acpi error return path
Date: Sun, 7 Oct 2007 14:54:00 -0400
User-Agent: KMail/1.9.7
Cc: toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710072053.02865.arvidjaar@mail.ru>
In-Reply-To: <200710072053.02865.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710071454.01010.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 October 2007, Andrey Borzenkov wrote:
> This fixes oops when registering backlight device fails. Attached as I still 
> cannot convince kmail to not mangle long lines ...
> 
> -andrey
> 

Re: kmail - it usually behaves well with the patches as long as
you turn off word wrapping and use "Insert file..." to insert
them.

-- 
Dmitry
