Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbXDXE2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbXDXE2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbXDXE2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:28:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbXDXE2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:28:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: James Morris <jmorris@namei.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH try #2] Return access error not ECHILD on security_task_wait
 failure
In-Reply-To: James Morris's message of  Monday, 23 April 2007 21:19:21 -0400 <Line.LNX.4.64.0704232117310.8557@d.namei>
X-Windows: all the problems and twice the bugs.
Message-Id: <20070424042817.67D0C1801A4@magilla.sf.frob.com>
Date: Mon, 23 Apr 2007 21:28:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not having tested it or anything, that looks good to me.


Thanks,
Roland
