Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYBRGTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYBRGTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYBRGTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:19:12 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:35042 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746AbYBRGTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:19:11 -0500
Message-ID: <47B9227E.9010909@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2008 11:45:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] memcgroup: return negative error code in mem_cgroup_create()
References: <47B91EC9.7080606@cn.fujitsu.com>
In-Reply-To: <47B91EC9.7080606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Cgroup requires the subsystem to return negative error code on
> error in the create method.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
