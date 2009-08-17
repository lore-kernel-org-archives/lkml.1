Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZHQFyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZHQFyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZHQFyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:54:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63423 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZHQFyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:54:12 -0400
Date: Sun, 16 Aug 2009 22:54:07 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH] scripts/ver_linux
In-Reply-To: <20090817054732.GK5039@cr0.nay.redhat.com>
Message-ID: <alpine.DEB.2.01.0908162250450.30417@bogon.housecafe.de>
References: <alpine.DEB.2.01.0908132251000.30417@bogon.housecafe.de> <20090817054732.GK5039@cr0.nay.redhat.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/5FEeKsJymdSKpWWtJc/d2Qq9phK88L5/tqCQ
 g/yFIkSwPREmzBw6QSnUSE9k/ljLYmULRJk+vwup7QEiRjLBqB
 XRp/BKbIgtQkAtB55Avug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 at 13:47, Amerigo Wang wrote:
> Hmm, so probably you are also using a Red Hat distribution?
> AFAIK, only some Fedora and RHEL don't have /sbin and /usr/sbin in $PATH.

No, Debian Linux - but as a mere user I never have sbin directories in my 
PATH. And since it is a headless system, I removed the console-* packages, 
that's why I did not have the "loadkeys" command installed. No big deal, 
but the ver_linux output looked weird....

Thanks for the ACK,
Christian.
-- 
BOFH excuse #424:

operation failed because: there is no message for this error (#1014)
