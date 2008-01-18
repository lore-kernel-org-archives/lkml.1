Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbYARL27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbYARL27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYARL2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:28:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:10561 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbYARL2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ikRdWfU5CQb8Ve/qtL2ayVCcocrrK2URlfitgmpMb6WCKHjVECvkpciDXr4mC8X/w7oswczrZDYuvRxt6e4nOad0ZV5QqG/XeZ7En5ZYGfWaUvphHCesviWASLoq0pEGtNgZhSk0C+aUXdO+1xrb5DDWBLnRm1vYFHBBXwV6m5A=
Date: Fri, 18 Jan 2008 12:26:23 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, IvDoorn@gmail.com
Subject: Re: Spammed logs again rt2500pci 2.6.24-rc8
Message-ID: <20080118122623.3561b3ed@Varda>
In-Reply-To: <1200653765.7492.10.camel@localhost>
References: <20080117225744.29aa214c@Varda>
	<1200653765.7492.10.camel@localhost>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 18 Jan 2008 11:56:05 +0100
Mattias Nissler <mattias.nissler@gmx.de> escribió:

> Hi,
> 
> we currently think this is due to a race condition in the packet queue
> code. Ivo is currently reworking the packet queues, which I hope will
> resolve this situation.

 Thanks for the quick answer. 

> 
> Mattias

 Regards;
 Alejandro

> 
> On Thu, 2008-01-17 at 22:57 +0100, Alejandro Riveira Fernández wrote:
> > Running
> > 
> > Linux Varda 2.6.24-rc8 #1 SMP PREEMPT Wed Jan 16 15:09:43 CET 2008 x86_64 GNU/Linux
> > 
> > my logs are spmmed with:
> > 
> > 
> > [20126.343240] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
> > [20126.343242] Please file bug report to http://rt2x00.serialmonkey.com.
> > [20126.848277] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 1.
>
> 
