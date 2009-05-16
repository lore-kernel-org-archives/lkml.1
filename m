Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZEPObZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZEPObZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 10:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZEPObP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 10:31:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:49291 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZEPObO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 10:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jl0GhAFkUJ73L8gWQntQBq4haGHWWjJWL3r34uji7AvFvDn6k9D94Mb5Khg0SDKbp7
         tm2kTmVudi8gV2AankvIqyIQFN7Zq8nrRFBI1aFE/umah59y18WyzDLoDdgsVLtmaHwS
         EN8KhPWmo0y4Y0BQ5gIhlUA/94av9+/3Oe6aQ=
MIME-Version: 1.0
In-Reply-To: <1239479565.8206.25.camel@localhost.localdomain>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>
	 <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain>
	 <8db1092f0904100747w297a0daas9ebd05486d06e706@mail.gmail.com>
	 <alpine.LFD.2.00.0904101819070.21577@localhost.localdomain>
	 <8db1092f0904100952x64048907gea6bbaf25488de26@mail.gmail.com>
	 <alpine.LFD.2.00.0904101854250.21577@localhost.localdomain>
	 <8db1092f0904101057x56000b73w9de3227b2a3a9abb@mail.gmail.com>
	 <alpine.LFD.2.00.0904102019220.21577@localhost.localdomain>
	 <a8e1da0904180604k8108bc5hf95705c42d80fcf9@mail.gmail.com>
	 <1239479565.8206.25.camel@localhost.localdomain>
Date: Sat, 16 May 2009 16:31:14 +0200
Message-ID: <8db1092f0905160731x17719d43m11a7f55d1b43c57f@mail.gmail.com>
Subject: Re: [2.6.29-git12] BUG: scheduling while atomic: swapper/0/0x10000100
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I already test 2.6.30-rc6, and problem seems be fixed.

Thanks
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
