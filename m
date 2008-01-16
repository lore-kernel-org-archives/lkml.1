Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYAPCRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYAPCRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYAPCRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:17:36 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:52659 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYAPCRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:17:35 -0500
Date: Tue, 15 Jan 2008 21:16:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH 4/4] RT: change from raw_spinlock_t to __raw_spinlock_t
Message-ID: <20080116021648.GH30532@goodmis.org>
References: <1200435706.4092.20.camel@bx740>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200435706.4092.20.camel@bx740>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:21:46PM -0800, Frank Rowand wrote:
> From: Frank Rowand <frank.rowand@am.sony.com>
> 
> Fix compile warning (which becomes compile error due to -Werror),
> by changing from raw_spinlock_t to __raw_spinlock_t.
> 

Applied.

Thanks,

-- Steve
