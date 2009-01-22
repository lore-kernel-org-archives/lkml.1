Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbZAVRTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbZAVRTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZAVRTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:19:15 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:45897 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbZAVRTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:19:14 -0500
Message-ID: <4978AA7F.5070306@oracle.com>
Date: Thu, 22 Jan 2009 09:18:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for January 22 (staging/rtl8187se)
References: <20090122180543.1ab0baa6.sfr@canb.auug.org.au> <4978A975.60002@oracle.com>
In-Reply-To: <4978A975.60002@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4978AA82.004F:SCFSTAT928724,ss=1,fgs=0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20090121:
> 
> 
> drivers/staging/rtl8187se/r8180_core.c:5973: error: 'struct net_device' has no member named 'wireless_handlers'
> drivers/staging/rtl8187se/r8180_core.c:5982: error: 'struct net_device' has no member named 'wireless_handlers'
> 
> 

and
drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c:845: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c:852: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'

-- 
~Randy
