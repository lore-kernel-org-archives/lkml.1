Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbXHAO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbXHAO3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXHAO3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:29:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33998 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbXHAO3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:29:06 -0400
From: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH, Vorsitzender des Aufsichtsrats: Johann Weihen, Geschaeftssfuehrung: Herbert Kircher, Sitz der Gesellschaft: Boeblingen, Registergericht: Amtsgericht Stuttgart, HRB 243294
To: Bob Nelson <rrnelson@linux.vnet.ibm.com>
Subject: Re: 2.6.22 new perfmon code base + libpfm + pfmon
Date: Wed, 1 Aug 2007 16:29:03 +0200
User-Agent: KMail/1.9.6
Cc: eranian@hpl.hp.com, linux kernel <linux-kernel@vger.kernel.org>,
       oprofile <oprofile-list@lists.sourceforge.net>
References: <20070726140222.GA7852@frankl.hpl.hp.com> <200708010922.41551.rrnelson@linux.vnet.ibm.com>
In-Reply-To: <200708010922.41551.rrnelson@linux.vnet.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708011629.03828.arnd.bergmann@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 August 2007, Bob Nelson wrote:
> It looks to me like you were saying you would remove this extension to the
> OProfile file system (/dev/oprofile/implementation).
> However, it looks like it has made it into the mainline kernel code. 

Just to be clear, this problem showed up in my own kernel patch set
from http://www.kernel.org/pub/linux/kernel/people/arnd/patches/2.6.22-arnd1/,
not in mainline.

	Arnd <><
