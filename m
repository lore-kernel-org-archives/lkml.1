Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZEOMF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZEOMF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZEOMFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:05:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZEOMFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:05:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH -tip 1/5] add asm-generic/dma-mappig-common.h
Date: Fri, 15 May 2009 14:05:37 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, joerg.roedel@amd.com
References: <1242359705-2117-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1242359705-2117-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242359705-2117-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151405.38518.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19C6KfH5Mdu11HQyHmuM4gH5VDzlt/wvrvZfUm
 9pxeEopfw/vHSYr3TpCp9ZIiTr7QIxQGgoAtgm+IF6gXR/XtSF
 fV72/LqtUFu+aKe11Su7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009, FUJITA Tomonori wrote:
> This header file provides some mapping function definitions that the
> users of struct dma_map_ops can use.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Acked-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
