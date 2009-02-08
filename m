Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbZBLNUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbZBLNUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 08:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZBLNUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 08:20:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34282 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbZBLNUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 08:20:33 -0500
Date: Mon, 9 Feb 2009 00:47:08 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Cheng Renquan <crquan@gmail.com>
Subject: Re: [PATCH] PM: Fix build for CONFIG_PM unset
Message-ID: <20090208234708.GA1415@ucw.cz>
References: <200901062112.29227.rjw@sisk.pl> <49922896.6090605@redhat.com> <200902111038.46368.rjw@sisk.pl> <200902112233.21529.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902112233.21529.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-02-11 22:33:20, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Compilation of kprobes.c with CONFIG_PM unset is broken due to some
> broken config dependncies.  Fix that.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Tested-by: Masami Hiramatsu <mhiramat@redhat.com>


Acked by: Pavel Machek <pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
