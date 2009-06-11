Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbZFKWZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbZFKWZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZFKWYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:24:55 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:22205 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbZFKWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:24:54 -0400
Message-ID: <4A318358.20804@oracle.com>
Date: Thu, 11 Jun 2009 15:21:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for June 11 (cnic)
References: <20090611191420.1f4d5e4f.sfr@canb.auug.org.au>
In-Reply-To: <20090611191420.1f4d5e4f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A318430.0129:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090610:


In 2 separate builds:

ERROR: "ip_route_output_key" [drivers/net/cnic.ko] undefined!

when CONFIG_INET=n

and

drivers/net/cnic.c:2520: error: implicit declaration of function '__symbol_get'

when CONFIG_MODULES=n


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
