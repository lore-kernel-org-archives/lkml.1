Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZBKQ6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZBKQ6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbZBKQ6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:58:22 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:60486 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbZBKQ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:58:21 -0500
Message-ID: <499303A3.2@oracle.com>
Date: Wed, 11 Feb 2009 08:58:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: mmotm 2009-02-10-16-35 uploaded (s1d13xfb)
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org>
In-Reply-To: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4993038C.0107:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.29-rc4:



mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:57: error: 'S1D13505_PROD_ID' undeclared here (not in a function)
mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:58: error: 'S1D13506_PROD_ID' undeclared here (not in a function)
mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:59: error: 'S1D13806_PROD_ID' undeclared here (not in a function)
mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c: In function 's1d13xxxfb_probe':
mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:637: error: 'struct s1d13xxxfb_par' has no member named 'prod_id'
mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:637: warning: statement with no effect
mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:638: error: 'struct s1d13xxxfb_par' has no member named 'revision'
mmotm-2009-0210-1635/drivers/video/s1d13xxxfb.c:638: warning: statement with no effect

-- 
~Randy
