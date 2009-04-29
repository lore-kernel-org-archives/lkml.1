Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbZD2PV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbZD2PV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZD2PVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:21:17 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:44476 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZD2PVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:21:15 -0400
Message-ID: <49F870A5.20809@oracle.com>
Date: Wed, 29 Apr 2009 08:22:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for April 29 (wireless/ath build failure)
References: <20090429173916.1a608076.sfr@canb.auug.org.au>
In-Reply-To: <20090429173916.1a608076.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49F87061.01DB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/net/wireless/ath/ar9170/usb.c:692: error: 'struct usb_device' has no member named 'reset_resume'

when CONFIG_PM=n.


-- 
~Randy
