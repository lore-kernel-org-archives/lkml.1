Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYDHXaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYDHXaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYDHX3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:29:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38011 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYDHX3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:29:54 -0400
Date: Wed, 9 Apr 2008 08:34:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pavel Emelianov <xemul@openvz.org>,
       hugh@veritas.com
Subject: Re: [-mm] Disable the memory controller by default (v3)
Message-Id: <20080409083449.d6a63259.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080408114613.8165.69030.sendpatchset@localhost.localdomain>
References: <20080408114613.8165.69030.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr 2008 17:16:13 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> Changelog v1
> 
> 1. Split cgroup_disable into cgroup_disable and cgroup_enable
> 2. Remove cgroup_toggle
> 
> Due to the overhead of the memory controller. The
> memory controller is now disabled by default. This patch adds cgroup_enable.
> 
> If everyone agrees on this approach and likes it, should we push this
> into 2.6.25?
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
Thank you for this boot option.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

