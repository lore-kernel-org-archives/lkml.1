Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZFRAIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZFRAIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZFRAIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:08:11 -0400
Received: from fd-2.mailout.artfiles.de ([212.72.187.61]:52670 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528AbZFRAIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:08:10 -0400
X-Greylist: delayed 1011 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2009 20:08:10 EDT
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "jmerkey@wolfmountaingroup.com" <jmerkey@wolfmountaingroup.com>
Date: Thu, 18 Jun 2009 01:51:39 +0200
Subject: RE: Xen vs. KVM
Thread-Topic: Xen vs. KVM
Thread-Index: AcntcBfnsBdX9pMZTP2bTPpk35hjfwCNBg0g
Message-ID: <520B2A28AACEE94388C511BBB8349337078B4889D6@IGR-IMC-01.corp.win-professional.com>
References: <57829.166.70.238.43.1245036804.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <57829.166.70.238.43.1245036804.squirrel@webmail.wolfmountaingroup.com>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/15 <jmerkey@wolfmountaingroup.com>

> I have worked with both KVM and XEN and to be honest, XEN is infested with
> bugs -- mostly of the paging type -- and you need an logic analyzer of an
> ICE to debug some of it.  I have nothing but trouble with it.  KVM is more
> stable but also sucks on performance, but I occasionally see the same
> issues.

This is bullshit.

KVM is buggy und very unstable. It´s NOT RECOMMENDED for production usage.

Xen is fully developed, fast and more reliable than KVM.
Thousands of companies are using Xen or Citrix XenServer and its super fast, easy to use and 100% rockstable!
The XEN PV Guest drivers are excellent in comparison with the KVM windows guest drivers. (after installing the 64 bit networking drivers with Server 2008 x64 > blue screen...).. I hate kvm.

@ Linus : Please merge xen as hypervisor into linux, right now !

-

Morten
