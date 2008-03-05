Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbYCEIrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbYCEIrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYCEIrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:47:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37709 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYCEIrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:47:35 -0500
Message-ID: <47CE5D41.3010506@cn.fujitsu.com>
Date: Wed, 05 Mar 2008 17:43:45 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: menage@google.com
CC: pj@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/2] Cpuset hardwall flag:  Switch cpusets to use the
 bulk cgroup_add_files() API
References: <20080305075237.608599000@menage.corp.google.com> <20080305080000.270536000@menage.corp.google.com>
In-Reply-To: <20080305080000.270536000@menage.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> This change tidies up the cpusets control file definitions, and
> reduces the amount of boilerplate required to add/change control files
> in the future.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Actually I've done this cleanup but don't have time to post the
patch. :)

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
