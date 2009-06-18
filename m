Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbZFRDHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbZFRDHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZFRDG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:06:56 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:54128 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZFRDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:06:56 -0400
Message-ID: <59150.166.70.238.43.1245291909.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <520B2A28AACEE94388C511BBB8349337078B4889D6@IGR-IMC-01.corp.win-profes
     sional.com>
References: <57829.166.70.238.43.1245036804.squirrel@webmail.wolfmountaingroup.com>
    <520B2A28AACEE94388C511BBB8349337078B4889D6@IGR-IMC-01.corp.win-professional.com>
Date: Wed, 17 Jun 2009 20:25:09 -0600 (MDT)
Subject: RE: Xen vs. KVM
From: jmerkey@wolfmountaingroup.com
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jmerkey@wolfmountaingroup.com" <jmerkey@wolfmountaingroup.com>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2009/6/15 <jmerkey@wolfmountaingroup.com>
>
>> I have worked with both KVM and XEN and to be honest, XEN is infested
>> with
>> bugs -- mostly of the paging type -- and you need an logic analyzer of
>> an
>> ICE to debug some of it.  I have nothing but trouble with it.  KVM is
>> more
>> stable but also sucks on performance, but I occasionally see the same
>> issues.
>
> This is bullshit.
>
> KVM is buggy und very unstable. It´s NOT RECOMMENDED for production usage.
>
> Xen is fully developed, fast and more reliable than KVM.
> Thousands of companies are using Xen or Citrix XenServer and its super
> fast, easy to use and 100% rockstable!
> The XEN PV Guest drivers are excellent in comparison with the KVM windows
> guest drivers. (after installing the 64 bit networking drivers with Server
> 2008 x64 > blue screen...).. I hate kvm.
>
> @ Linus : Please merge xen as hypervisor into linux, right now !
>
> -
>
> Morten
>

They are both buggy.  but Xen is BUGGIER.

Before you call bullshit try eating your own dogfood.  I threw both of
these pieces of shit away in the trash and went back to VMWare, which is
slower than crap, but it least it fucking works.

Jeff



