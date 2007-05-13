Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbXEMXGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbXEMXGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbXEMXGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:06:35 -0400
Received: from main.gmane.org ([80.91.229.2]:47880 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbXEMXGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:06:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bob Johnston <haloman@gmail.com>
Subject: Re: undeprecate raw driver.
Date: Sun, 13 May 2007 23:01:51 +0000 (UTC)
Message-ID: <loom.20070514T005958-424@post.gmane.org>
References: <E1HnHxK-0004CI-00@calista.eckenfels.net> <Pine.LNX.4.64.0705131347450.1144@localhost.localdomain> <464770A0.4070809@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 137.222.211.69 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.3) Gecko/20070309 Firefox/2.0.0.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr <at> s5r6.in-berlin.de> writes:
> So why don't we simply say:
> 
>   - "Users of feature A are urged to migrate to alternative B."
>   - "Feature C will be removed in February 2038."
> 
> Everybody understands the meaning of /that/.

Why not just use the terms:
* outdated - as a replacement for "deprecated".
* toberemoved - as a replacement for "obsolete".

These terms are easy to understand, short, universally accepted and extremely
difficult to get wrong.

