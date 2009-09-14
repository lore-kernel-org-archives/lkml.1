Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbZINU5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbZINU5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZINU5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:57:44 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:47701 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZINU5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yGDNABuC6tq4hIbJtNt6ACqyRObC6hGhcZQmuHNS6MLxQwFaOMSoq5sGNfe67yXm0g
         P65JtN9sIlvsmeSqbWtlOmvK44JT8kjQpBZGUkJeADjHikrXXnFAI9rRp30QAelsNiyC
         pvqhrNUZORo16DuE7epHXXbAHETEY8Zzkh0vk=
MIME-Version: 1.0
In-Reply-To: <1252961412.11643.215.camel@desktop>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org> 
	<1252961412.11643.215.camel@desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Sep 2009 16:57:27 -0400
Message-ID: <8bd0f97a0909141357y60d7807bm99146d757e6f61da@mail.gmail.com>
Subject: Re: [PATCH 00/72] Blackfin updates for 2.6.32
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 16:50, Daniel Walker wrote:
> On Mon, 2009-09-14 at 16:07 -0400, Mike Frysinger wrote:
>> Minor highlights:
>>  - shadow console to help with really early kernel output
>>  - proper decoding of double fault handling
>>
>> Otherwise, we've got the normal bug fixes, IPIPE updates, and clean ups.
>>
>
> Patches 15, 16, 20, 21, and 61 all have checkpatch errors some with
> several errors..  Could you clean those up those errors before sending
> this up stream?

i already checked/reviewed the output in the series
-mike
