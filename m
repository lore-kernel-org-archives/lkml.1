Return-Path: <linux-kernel-owner+w=401wt.eu-S1760429AbYBZDhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429AbYBZDhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYBZDgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:36:53 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:39230 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758251AbYBZDgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:36:20 -0500
Message-ID: <47C387EC.4070900@linux.vnet.ibm.com>
Date: Tue, 26 Feb 2008 09:00:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Memory Resource Controller use strstrip while parsing
 arguments
References: <20080225182746.9512.21582.sendpatchset@localhost.localdomain> <20080225105606.bcab215e.akpm@linux-foundation.org>
In-Reply-To: <20080225105606.bcab215e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 25 Feb 2008 23:57:46 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> The memory controller has a requirement that while writing values, we need
>> to use echo -n. This patch fixes the problem and makes the UI more consistent.
> 
> that's a decent improvement ;)
> 
> btw, could I ask that you, Paul and others who work on this and cgroups
> have a think about a ./MAINTAINERS update?

Aah.. yes.. we should do that.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
