Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbXFWME2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbXFWME2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 08:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXFWMEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 08:04:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54705 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXFWMEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 08:04:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: spock@gentoo.org
Subject: Re: [PATCH 0/4] fbdev: uvesafb
Date: Sat, 23 Jun 2007 14:04:09 +0200
User-Agent: KMail/1.9.6
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070623104920.GA12623@spock.one.pl>
In-Reply-To: <20070623104920.GA12623@spock.one.pl>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706231404.09344.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19amJPpk4l8nVzoIm93CKbgKMZLBhk42kX0XrY
 EihoOYasfaMp9G98q+WMzfdsnieVwNN5g862YRONWC+xvSZFB3
 ngfvdNkp6D6PVTI3LAY5g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Michal Januszewski wrote:
>  The current implementation of v86d can use either LRMI or
> x86emu to run the BIOS code and supports both x86 and x86_64.

Is there a fundamental reason why you can't also run it on
non-x86 machines, or has this simply not been tested so far?

	Arnd <><
