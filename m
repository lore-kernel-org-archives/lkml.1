Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbXFUXNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbXFUXNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbXFUXM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:12:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXFUXM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:12:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: NUMA BOF @OLS
Date: Fri, 22 Jun 2007 01:12:51 +0200
User-Agent: KMail/1.9.6
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706211316150.9220@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706211316150.9220@schroedinger.engr.sgi.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706220112.51813.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19+E0PJaOQNyeVdG1m8YuVaYvCYCi6AozDIJ86
 v/bGjAO39AzGy9ZKNqrlDBQVhh3NurDA7s7XjoPUfXDUtkJQKh
 +RBPBaO6zFo3Gl0Mt+cgQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2007, Christoph Lameter wrote:
> If you have another subject that should be brought up then please contact 
> me.

- Interface for preallocating hugetlbfs pages per node instead of system wide

- architecture independent in-kernel API for enumerating CPU sockets with
  multicore processors (not sure if that's the same as your existing subject).

	Arnd <><
