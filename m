Return-Path: <linux-kernel-owner+w=401wt.eu-S1751233AbYKNFQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbYKNFQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 00:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYKNFQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 00:16:16 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:58545 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbYKNFQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 00:16:16 -0500
Message-ID: <491D0991.4080408@oracle.com>
Date: Thu, 13 Nov 2008 21:16:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: a.zummo@towertech.it
Subject: Re: mmotm 2008-11-13-17-22 uploaded (RTC build error)
References: <200811140122.mAE1MeAG015836@imap1.linux-foundation.org>
In-Reply-To: <200811140122.mAE1MeAG015836@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.491D0994.002B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  drivers/rtc/rtc-dev.o
mmotm-2008-1113-1722/drivers/rtc/rtc-dev.c: In function 'rtc_dev_prepare':
mmotm-2008-1113-1722/drivers/rtc/rtc-dev.c:505: error: assignment of read-only location

-- 
~Randy
