Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbYFKSJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbYFKSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbYFKSJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:09:41 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:10576 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbYFKSJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=H+XWE/CgMXC8cve1I15dEE0rDwKyUUksuP+Hr9MkbjDE7hzf3vvkKBZdoyI2gjWA14
         oTZ6Lr/GbeKnEXTI2bsnYEDAaN26xxj6Qk4qdTaMaht9yvQxuX82uK9wfXKBr8sEf9NI
         fgtCtsj9O0hdRVKVbM9Xgt3EHing73cj6LUSM=
To: =?iso-8859-1?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Date: Wed, 11 Jun 2008 20:21:49 +0200
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
References: <20080601193000.GA3056@ime.usp.br> <20080609001540.GA19072@ime.usp.br> <20080611093605.GA13557@ime.usp.br>
In-Reply-To: <20080611093605.GA13557@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112021.50264.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Oh, these endianness problems are a headache. I just fixed some in one
> small program in lame (the MP3 compressor), but in the end, I finally
> won. :-)
> 
> Anyway, did you have some time to check your D-Link stick? I am willing to
> test more things or other kernel trees, if that is helpful to the project.

Kernel is compiling right now, I did attempt to test this earlier,
but something has changed in the IDE/SATA drivers or something
because I 2.6.26 no longer recognized my hard disk during boot which
obviously makes booting quite complicated. ;)

Ivo
