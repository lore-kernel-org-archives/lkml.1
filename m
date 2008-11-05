Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYKEN5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYKEN5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYKEN5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:57:00 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:57136 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYKEN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:56:59 -0500
Message-ID: <4911A5D7.8090505@linux.vnet.ibm.com>
Date: Wed, 05 Nov 2008 19:25:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [mm] [PATCH 1/4] Memory cgroup hierarchy documentation
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop> <20081101184824.2575.5935.sendpatchset@balbir-laptop> <6599ad830811032225w229d3a29k17b9a38cb76a521f@mail.gmail.com> <6599ad830811032226h4c4a81d4hb030953a4e0906db@mail.gmail.com>
In-Reply-To: <6599ad830811032226h4c4a81d4hb030953a4e0906db@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Nov 3, 2008 at 10:25 PM, Paul Menage <menage@google.com> wrote:
>> That's not a very intuitive interface. Why not memory.use_hierarchy?
> 
> Or for consistency with the existing cpuset.memory_pressure_enabled,
> just memory.hierarchy_enabled ?

Yes, I can change it to that.

-- 
	Balbir
