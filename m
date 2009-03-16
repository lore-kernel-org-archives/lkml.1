Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZCPSc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZCPSc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZCPScS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:32:18 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:27905 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZCPScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:32:17 -0400
Message-ID: <49BE9B20.70808@oracle.com>
Date: Mon, 16 Mar 2009 11:32:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 16 (slob)
References: <20090316220609.6f4a884c.sfr@canb.auug.org.au>
In-Reply-To: <20090316220609.6f4a884c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49BE9B27.01A3:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090312:


mm/slob.c:480: error: 'flags' undeclared (first use in this function)


pseudo-patch:

s/flags/gfp/


~Randy


