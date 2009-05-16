Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbZEPLXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbZEPLXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 07:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZEPLXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 07:23:45 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:43301 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZEPLXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 07:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=pM018/gMRpbq+c5z3MnLxiPilkH9nZvP2KMjK7tj8sG0i4dOUtXgb5NfkFBKtuyRvv
         1kAcLw9pfn7nIr0I65lYaNEK4K9pr45idr140VjpXBzoIwkVMwTD0W/1c9Idc2EuQuXp
         yRg+UGu/BLbG30EMCSX3668dicF3tEnmn0X10=
Date: Sat, 16 May 2009 13:23:36 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux 2.6.30-rc6
Message-ID: <20090516132336.5e73542e@varda>
In-Reply-To: <4A0E62D4.5080004@garzik.org>
References: <alpine.LFD.2.01.0905152120140.3301@localhost.localdomain>
	<4A0E62D4.5080004@garzik.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 16 May 2009 02:53:08 -0400
Jeff Garzik <jeff@garzik.org> escribió:

[...]
> 
> 
> 
> "2.6.30-rc6-00000-rc6" seems like something is broken, as building a 
> released version from git always gave me a proper "2.6.30-rc5"-style 
> version, as expected.

 Happened the same to me with rc5. did not find it important enough to report


Linux varda 2.6.30-rc5-00000-rc5 #55 SMP PREEMPT Sat May 9 04:00:29 CEST 2009 x86_64 GNU/Linux

> 
> Attached .config.
> 
> 	Jeff
> 
> 
> 
> 
