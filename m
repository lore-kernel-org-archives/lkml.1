Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0BAQ7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:59:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39675 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0BAQ73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:59:29 -0500
Message-ID: <4B67086D.6040202@us.ibm.com>
Date: Mon, 01 Feb 2010 08:59:25 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rostedt@goodmis.org
Subject: Re: [PATCH 0/3 V2] trace-cmd: compiler warning fixes
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
In-Reply-To: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

You can pull these from the latest for-rostedt/master git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/trace-cmd.git for-rostedt/master


Darren Hart wrote:
> The following series fixes a few minor compiler warnings. These are
> mostly printf format type issues. Also includes an uninitialized
> variable fix.
> 
> V2: actually send my patches and not 2 of rostedts...
> --
> Darren Hart
> IBM Linux Technology Center
> Real-Time Linux Team
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
