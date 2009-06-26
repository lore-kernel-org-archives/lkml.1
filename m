Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbZFZQEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbZFZQEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZFZQEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:04:37 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:52191 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZFZQEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:04:36 -0400
Message-ID: <4A44F18D.2000608@oracle.com>
Date: Fri, 26 Jun 2009 09:04:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 26 (cyclades)
References: <20090626154605.ac73b738.sfr@canb.auug.org.au>
In-Reply-To: <20090626154605.ac73b738.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A44F190.005F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090625:


drivers/char/cyclades.c:3332: error: assignment of read-only location

(it's const)


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
