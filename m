Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbXGBTpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbXGBTpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXGBToy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:44:54 -0400
Received: from bizon.gios.gov.pl ([212.244.124.8]:47175 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbXGBTox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:44:53 -0400
X-Greylist: delayed 1656 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2007 15:44:53 EDT
Date: Mon, 2 Jul 2007 21:16:57 +0200 (CEST)
From: Krzysztof Oledzki <ole@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Phil Dibowitz <phil@ipom.com>
cc: Andreas Steinmetz <ast@domdv.de>, Jan Engelhardt <jengelh@computergmbh.de>,
       netfilter-devel@lists.netfilter.org,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: mss to pmtu clamping partially broken?
In-Reply-To: <20070702182850.GB14507@ipom.com>
Message-ID: <Pine.LNX.4.64.0707022113330.25153@bizon.gios.gov.pl>
References: <4684E853.20900@domdv.de> <Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
 <4689300C.9050802@domdv.de> <20070702182850.GB14507@ipom.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2069770357-1183403817=:25153"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2069770357-1183403817=:25153
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 2 Jul 2007, Phil Dibowitz wrote:

> On Mon, Jul 02, 2007 at 07:04:12PM +0200, Andreas Steinmetz wrote:
>> Jan Engelhardt wrote:
>>> Do you really need clamping? It's a hack, since TCP should do MSS negot=
iation
>>> itself. (Of course it may happen that some routers are broken.) But usu=
ally not
>>> for incoming packets.
>>
>> You never know when you hit ICMP blackholes, broken routers and other
>> evil things. Better safe than sorry so clamping is the way to go for me.
>
> I encourage you to report PMTUD Blackholes to the MSS Initiative at
> http://www.phildev.net/mss/

Any chances for similar initiative for "SACK vandals"? ;)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2069770357-1183403817=:25153--
