Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbXJXEdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbXJXEdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbXJXEdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:33:17 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51752 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbXJXEdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:33:16 -0400
Date: Wed, 24 Oct 2007 10:15:37 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] CFS CGroup: Code cleanup
Message-ID: <20071024044537.GB7099@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <471EAEBB.8000302@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471EAEBB.8000302@google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 07:32:27PM -0700, Paul Menage wrote:
> Clean up some CFS CGroup code
> 
> - replace "cont" with "cgrp" in a few places in the CFS cgroup code, 
> - use write_uint rather than write for cpu.shares write function
> 
> Signed-off-by: Paul Menage <menage@google.com>

Acked-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

-- 
Regards,
vatsa
