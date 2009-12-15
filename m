Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZLOTmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZLOTmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZLOTmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:42:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39465 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZLOTmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=UZsqgXzPgGerosdz8GQ/4zE8zno7WtniFTPz7HeTIxylrfNb1dtUJ4DTaQ/GZglZoD
         V7vj4HVlQXyBbGhbLgRz6tznYxlgc+Aswatoq/7CLxdMctHEY+7qt0d4HkyOpTQXnf52
         lD3RuRZQbaa21/k9RwgMhmIojxlU3IYrPD8S4=
Date: Tue, 15 Dec 2009 20:42:33 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32 build problem on Mint 8 (kubuntu-9.10 i86-x64)
Message-ID: <20091215204233.2dca0783@varda>
In-Reply-To: <200912151426.26285.gene.heskett@verizon.net>
References: <200912151426.26285.gene.heskett@verizon.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 15 Dec 2009 14:26:26 -0500
Gene Heskett <gene.heskett@verizon.net> escribió:

> Greetings;
[...]
> 
> The  I tried a 'make menuconfig' which also quits quickly because it can't 
> find the ncurses stuff either.

 sudo aptitude install build-essential libncurses5-dev

> 
> At this point, maybe I should have tried as root rather than as a common 
> user, me, but I'm told its better not to build this stuff as root.
> 
> I took some pix, where should I post them?
> 
