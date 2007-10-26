Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbXJZJEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbXJZJEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXJZJEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:04:38 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:57251 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXJZJEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lODoKcoZHYPZD3ebHjn/V69P2LflN1QAW1wbS04gbn/BAqksMkYEOWgfD938x2BnHSLjbiLTiX0dDDACYv5ypJZHpszktLg5OT9qAL4P3UYfhFtOLOsivfErAWF99EOZRCyRVHJkwpJoVLj4XacfjzN/IAZOOPO9D1/BPwel334=
Message-ID: <fceeb6990710260204o5ecab9abm944be41ee57acd6c@mail.gmail.com>
Date: Fri, 26 Oct 2007 11:04:36 +0200
From: "Piero Ottuzzi" <lkmltimes@gmail.com>
To: "Mikael Starvik" <mikael.starvik@axis.com>
Subject: Re: Upcomming CRIS patches
Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       "Jesper Nilsson" <Jesper.Nilsson@axis.com>
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C66804C4011D@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BFECAF9E178F144FAEF2BF4CE739C6680547FAFA@exmail1.se.axis.com>
	 <BFECAF9E178F144FAEF2BF4CE739C66804C4011D@exmail1.se.axis.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/26, Mikael Starvik <mikael.starvik@axis.com>:
> >Are there access to a cross-compile chain for i386 somewhere?
>
> Sure, that's the only way we do it (CRIS has typically too low performance
> and memory to compile anything although it has been shown that it is
> possible)
>
> You can find the compiler at
> http://www.axis.com/reg/login.php?oldurl=/products/dev_sdk/download_compiler
> .php.
> Unfortunately you have to register.
>

Hi there,

you can download the compiler without registration at [1].

Bye
Piero
[1]http://www.axis.com/ftp/pub/axis/tools/cris/compiler-kit/
