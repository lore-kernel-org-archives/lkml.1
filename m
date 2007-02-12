Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXBLPev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXBLPev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXBLPev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:34:51 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42565 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000AbXBLPeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:34:50 -0500
Date: Mon, 12 Feb 2007 21:04:10 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 6/7] containers (V7): BeanCounters over generic process containers
Message-ID: <20070212153410.GE7526@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.998727000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.998727000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:27AM -0800, menage@google.com wrote:
> This patch implements the BeanCounter resource control abstraction
> over generic process containers. 

Forgive my confusion, but do we really need two-levels of resource control 
abstraction here? Why can't resource controllers directly work with containers 
(just like cpu accounting does)?

-- 
Regards,
vatsa
