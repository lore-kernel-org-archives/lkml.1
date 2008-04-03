Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbYDCAUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbYDCAUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYDCAT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:19:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60791 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbYDCAT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:19:59 -0400
Subject: Re: [PATCH 0/4] Container Freezer: Reuse Suspend Freezer
From: Matt Helsley <matthltc@us.ibm.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, linux-pm@lists.linux-foundation.org
In-Reply-To: <20080403001529.052250759@us.ibm.com>>
References: <20080403001529.052250759@us.ibm.com>>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 02 Apr 2008 17:19:56 -0700
Message-Id: <1207181996.15616.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-02 at 17:15 -0700, Matt Helsley wrote:

<snip>
> * Series
> 
>   Applies to 2.6.25-rc8-mm1
> 
>   The first patches make the freezer available to all architectures
>   before implementing the freezer subsystem.
> 
> [PATCH 1/4] Add TIF_FREEZE flag to all architectures
> [PATCH 2/4] Make refrigerator always available
> [PATCH 3/4] Implement freezer cgroup subsystem
> [PATCH 4/4] Skip frozen cgroups during power management resume

Argh. I forgot to add [RFC] tags to all of these!

>   Each patch compiles, boots, and survives basic LTP containers and controllers 
>   	tests.
>   
> Comments are welcome.
> 
> Cheers,
> 	-Matt Helsley
> 

