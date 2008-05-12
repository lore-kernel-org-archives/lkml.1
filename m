Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYELNYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYELNYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYELNYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:24:06 -0400
Received: from c60.cesmail.net ([216.154.195.49]:15518 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbYELNYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:24:05 -0400
Subject: Re: [PATCH] module: fix panic in is_imv_cond_end_module()
From: Pavel Roskin <proski@gnu.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1210598269.7921.5.camel@dv>
References: <1210598269.7921.5.camel@dv>
Content-Type: text/plain
Date: Mon, 12 May 2008 09:24:03 -0400
Message-Id: <1210598643.7921.8.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-12 at 09:17 -0400, Pavel Roskin wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
> The patch is for mingo/linux-2.6-ftrace.git repository.

I see it's in linux-2.6-sched-devel already.  Sorry for the noise.

-- 
Regards,
Pavel Roskin
