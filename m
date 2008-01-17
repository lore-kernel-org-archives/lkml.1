Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYARKeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYARKeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbYARKdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:33:47 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:59868 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755720AbYARKdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:33:45 -0500
Date: Thu, 17 Jan 2008 23:28:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, jlan@sgi.com, nagar@watson.ibm.com,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] getdelays: fix gcc warnings
Message-ID: <20080117175853.GA7059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	lkml <linux-kernel@vger.kernel.org>, jlan@sgi.com,
	nagar@watson.ibm.com, akpm <akpm@linux-foundation.org>
References: <20080115160506.b1360614.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080115160506.b1360614.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com> [2008-01-15 16:05:06]:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix gcc warnings in getdelays.c:

Hi, Randy,

Thanks for finding these problems and fixing them. The fixes look
quite straight forward.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
