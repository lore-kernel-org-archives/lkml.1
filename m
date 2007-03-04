Return-Path: <linux-kernel-owner+w=401wt.eu-S1751398AbXCDLPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbXCDLPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 06:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXCDLPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 06:15:06 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:55547 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbXCDLPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 06:15:04 -0500
Message-ID: <45EAAA37.5080706@in.ibm.com>
Date: Sun, 04 Mar 2007 16:45:03 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] [RSDL 1/6] lists: add list splice tail
References: <200703041802.13991.kernel@kolivas.org>
In-Reply-To: <200703041802.13991.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> Add a list_splice_tail variant of list_splice.
> 
> Patch-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Con Kolivas <kernel@kolivas.org>
> 

Acked-by: Balbir Singh <balbir@in.ibm.com>

I had the same exact patch in my memcontrol at
http://lkml.org/lkml/2007/2/24/68 (see the last
two functions).


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
