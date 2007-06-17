Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbXFQWlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbXFQWlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 18:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXFQWlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 18:41:12 -0400
Received: from [212.12.190.81] ([212.12.190.81]:32859 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752980AbXFQWlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 18:41:11 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: How to improve the quality of the kernel?
Date: Mon, 18 Jun 2007 01:41:41 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706180141.41101.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Sunday 17 June 2007, Andrew Morton wrote:
> > We of course do want to minimise the amount of overhead for each
> > developer. I'm a strong believer in specialisation: rather than
> > requiring that *every* developer/maintainer integrate new steps in their
> > processes it would be better to allow them to proceed in a
> > close-to-usual fashion and to provide for a specialist person (or team)
> > to do the sorts of things which you're thinking about.
>
> Makes sense... however we need to educate each and every developer about
> importance of the code review and proper recognition of reviewers.

That's as easy to manage as is currently done with rc-regressions.

Maybe Adrian can introduce a "Patch Review Tacking" system akin to the his 
"rc-Regression Tracking" system.


Thanks!

--
Al

