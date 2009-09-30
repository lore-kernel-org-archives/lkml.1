Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZI3Iuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZI3Iuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZI3Iuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:50:50 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51005 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZI3Iut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:50:49 -0400
Date: Wed, 30 Sep 2009 09:51:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tracing: Fix infinite loop in ftrace_update_pid_func()
Message-ID: <20090930085127.GA6512@console-pimps.org>
References: <1254152581-18347-1-git-send-email-matt@console-pimps.org> <20090929092245.GA5057@nowhere> <1254300075.7286.2.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254300075.7286.2.camel@frodo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 04:41:15AM -0400, Steven Rostedt wrote:
> 
> Matt,
> 
> Thanks, I'll pull this in as soon as I get back from Dresden.
> 
> -- Steve

Thanks Steve!
