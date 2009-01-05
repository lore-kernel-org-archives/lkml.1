Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZAEUMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZAEUMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZAEUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:12:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:13045 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZAEUMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:12:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cEnaeSfEablCqWu2VSAbD/hO/G6AWfTssn8Mb/k9IkTvbjTg/pLnSZV+qp8a94VN+5
         InpfVgQM2pVSqK6Q3zish71xTRoLoYI6UCrLELKO/5FuJVC0GxSRnoljYEuEq9jf5H5O
         t9Eka8KBESGQ7tM1xeH7f5pFfcNioXjhBXTKs=
Date: Mon, 5 Jan 2009 22:12:53 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: penberg@cs.helsinki.fi, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: Remove the relay version of kmemtrace.
Message-ID: <20090105201252.GD5196@localhost>
References: <20090105191330.GA1498@elte.hu> <1231186198-15437-1-git-send-email-eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231186198-15437-1-git-send-email-eduard.munteanu@linux360.ro>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:09:58PM +0200, Eduard - Gabriel Munteanu wrote:
> kmemtrace now uses ftrace. This patch removes the relay version.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

I still have to port kmemtrace+ftrace to tracepoints, I'll get back to
you soon.


	Cheers,
	Eduard

