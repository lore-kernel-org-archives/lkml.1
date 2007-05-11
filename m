Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXEKHk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXEKHk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbXEKHkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:40:22 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:40416 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXEKHkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:40:22 -0400
Date: Fri, 11 May 2007 09:40:20 +0200
Message-Id: <1783707000@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: akpm@linux-foundation.org, kenchen@google.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-git11: BUG in loop.ko
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/LIjsLoMTGTbgD8SkiuvXVuDyP88j66R5ycIJqePZFgQBZx
 dcELUAExAdcdWOfxiKOFEVQcwKLr5UPRhtM4gZBxLE0/n7xjTs=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>+ modprobe loop max_loop=128
>loop: the max_loop option is obsolete and will be removed in March 2008

looks like fc6 already contains that "remove artificial software max_loop limit" patch ?

what about mainline - will it be in 2.6.22, as andrew "estimated" when the patch showed up?

i`m asking, because i`m just curious - seems that this was put "on hold" - so someone confirm we need to wait for 2.6.23 or later?

sorry for the noise
roland

_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

