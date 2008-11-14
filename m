Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbYKNFTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbYKNFTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 00:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbYKNFSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 00:18:52 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:18518 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYKNFSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 00:18:51 -0500
Message-ID: <491D0A32.1020401@oracle.com>
Date: Thu, 13 Nov 2008 21:18:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tiwai@suse.de
Subject: Re: mmotm 2008-11-13-17-22 uploaded (pc-speaker)
References: <200811140122.mAE1MeAG015836@imap1.linux-foundation.org>
In-Reply-To: <200811140122.mAE1MeAG015836@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.491D0A34.00AC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mmotm-2008-1113-1722/sound/drivers/pcsp/pcsp.c: In function 'snd_card_pcsp_probe':
mmotm-2008-1113-1722/sound/drivers/pcsp/pcsp.c:99: error: 'HRTIMER_CB_IRQSAFE' undeclared (first use in this function)

# CONFIG_SND_HRTIMER is not set

-- 
~Randy
