Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbZBDRTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbZBDRTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZBDRTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:19:23 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:18321 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZBDRTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:19:23 -0500
Message-ID: <4989CE0A.6060603@oracle.com>
Date: Wed, 04 Feb 2009 09:19:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: Tree for February 4 (sound/isa/msnd)
References: <20090204192215.1045f2aa.sfr@canb.auug.org.au>
In-Reply-To: <20090204192215.1045f2aa.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4989CE09.00B7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090203:
> 
> Undropped trees:
> 	sound


When CONFIG_PNP=n:

sound/isa/msnd/msnd_pinnacle.c:891: error: 'isapnp' undeclared (first use in this function)



-- 
~Randy
