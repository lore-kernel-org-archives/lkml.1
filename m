Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbYKNLeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYKNLeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 06:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYKNLel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 06:34:41 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:60131 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYKNLek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 06:34:40 -0500
Message-ID: <491D61FA.3050704@linux.vnet.ibm.com>
Date: Fri, 14 Nov 2008 17:03:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       pbadari@us.ibm.com, jblunck@suse.de, taka@valinux.co.jp,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] memcg updates (14/Nov/2008)
References: <20081114191246.4f69ff31.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081114191246.4f69ff31.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Several patches are posted after last update (12/Nov),
> it's better to catch all up as series.
> 
> All patchs are mm-of-the-moment snapshot 2008-11-13-17-22
>   http://userweb.kernel.org/~akpm/mmotm/
> (You may need to patch fs/dquota.c and fix kernel/auditsc.c CONFIG error)
> 
> New ones are 1,2,3 and 9. 
> 
> IMHO, patch 1-4 are ready to go. (but I want Ack from Balbir to 3/9)

Hi, Kamezawa,

Sorry to keep you waiting, I've been spending time on memcg hierarchy patches
(testing, fixing, revisiting them). Hopefully, I'll find some time quickly.

-- 
	Balbir
