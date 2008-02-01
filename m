Return-Path: <linux-kernel-owner+w=401wt.eu-S1762353AbYBAL6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762353AbYBAL6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYBAL6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:58:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:57798 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYBAL6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:58:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=oQblu9YAJEWtTiafsXZf4grKOprlx/WbqLa4Fb5WMh9sU/GnOVlL6NbQ372iYJX9Hekqq4rr8sSoih4+pDcNjUlH6jaWlxhAN1X4fa27IEJRTQF6oAxbk3M2q43l8pzG52SZhnbLhcQPLDN+YlU+XeJSVoBVUtti+G8tLSMUv8s=
Date: Fri, 1 Feb 2008 12:53:50 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz
Subject: Re: how to tell i386 from x86-64 kernel
Message-ID: <20080201125350.04211519@Varda>
In-Reply-To: <Pine.LNX.4.64.0802010157370.4864@fbirervta.pbzchgretzou.qr>
References: <20080201004212.GA2818@elf.ucw.cz>
	<2c0942db0801311646s40368a89r537a7d576ba57981@mail.gmail.com>
	<Pine.LNX.4.64.0802010157370.4864@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 1 Feb 2008 01:59:03 +0100 (CET)
Jan Engelhardt <jengelh@computergmbh.de> escribió:


> 
> # uname -m
> I won't tell you.
> # linux32 uname -m
> i686

 Ubuntu 7.10 64 bit userland 2.6.24

$ uname -m
x86_64
$ linux32 uname -m
i686



> 
> Now what? :-)
> 
> Well, the answer is simple, a 64-bit kernel will allow you
> (minus selinux voodoo) to load 64-bit binaries.
