Return-Path: <linux-kernel-owner+w=401wt.eu-S1763237AbYALSgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763237AbYALSgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 13:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbYALSgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 13:36:38 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:36828 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755921AbYALSgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 13:36:37 -0500
Date: Sun, 13 Jan 2008 00:06:07 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: Updatedb hangs Kernel 2.6.22.9-cfs-v22
Message-ID: <20080112183607.GA10926@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <478900FF.2000706@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478900FF.2000706@mandic.com.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 04:03:43PM -0200, Renato S. Yamane wrote:
> Hi,
> I can't use updatedb in Debian Etch (stable) using customized Kernel 
> 2.6.22.9-cfs-v22.
>

Hi,

Can you see if it happens with the latest CFS backport. Its been updated
quite a bit since then. You can find it at
http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.6.22.15-v24.1.patch

> When I ran updatedb, after ~1 minute my system hangs and "caps lock" LED is 
> blinking. No log is registered.
>

-- 
regards,
Dhaval
