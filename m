Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbZFQQaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbZFQQaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZFQQaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:30:14 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:34766 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZFQQaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:30:12 -0400
Message-ID: <4A39194B.2060200@oracle.com>
Date: Wed, 17 Jun 2009 09:26:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: linux-next: Tree for June 17 (pci/slot)
References: <20090617155354.075c60ae.sfr@canb.auug.org.au>
In-Reply-To: <20090617155354.075c60ae.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A391A10.0178:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090616:


When CONFIG_SYSFS=n:

drivers/pci/slot.c:327: error: 'module_kset' undeclared (first use in this function)

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
