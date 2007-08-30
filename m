Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXH3SeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXH3SeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbXH3SeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:34:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52498 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758744AbXH3SeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:34:15 -0400
Date: Thu, 30 Aug 2007 19:34:02 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Rob Landley <rob@landley.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
Message-ID: <20070830183402.GA17084@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com> <46D4CC81.4060400@zytor.com> <200708301432.11516.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708301432.11516.rob@landley.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 02:32:11PM -0500, Rob Landley wrote:
> (If sysctlfs wasn't part of proc, that would be less of an issue, but we need 
> union mounts for that...)

Not at all.  all sysctls are under /proc/sys/
