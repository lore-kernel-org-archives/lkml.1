Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYKUEWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYKUEWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 23:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYKUEV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 23:21:57 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:16581 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYKUEV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 23:21:56 -0500
Message-ID: <49263752.5050909@oracle.com>
Date: Thu, 20 Nov 2008 20:21:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       h-shimamoto@ct.jp.nec.com
Subject: Re: [PATCH 2/3] proc: Export statistics for softirq to /proc
References: <20081120195542.c85d4967.kobayashi.kk@ncos.nec.co.jp> <20081120195843.c6d0b653.kobayashi.kk@ncos.nec.co.jp> <20081121041643.GA5366@x200.localdomain>
In-Reply-To: <20081121041643.GA5366@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49263755.0094:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Thu, Nov 20, 2008 at 07:58:43PM -0800, Keika Kobayashi wrote:
>> Export statistics for softirq in /proc/softirqs and /proc/stat.
> 
> I thought we added debugfs to stop adding these and similar stuff to /proc.

This doesn't look like debugfs material to me.
It's just another component of /proc/stat or /proc/interrupts or wherever.

-- 
~Randy
