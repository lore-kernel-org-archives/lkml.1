Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZJ2Is3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZJ2Is3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZJ2Is3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:48:29 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:44136
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbZJ2Is2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:48:28 -0400
Date: Thu, 29 Oct 2009 09:48:23 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Message-ID: <20091029084823.GA21172@gibson.comsick.at>
References: <20091027095014.GA22215@gibson.comsick.at>
 <200910271138.01624.elendil@planet.nl>
 <20091027140018.GF8900@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027140018.GF8900@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Oct 09 14:00, Mel Gorman wrote:
> Specifically, this looks very like the bug
> 
> "page allocation failure message kernel 2.6.31.4 (tty-related)"
> 
> The first three patches on the thread Frans Pop are expected to close
> that one out. Michael, I'm hoping they'll help you too. Whether they
> help or not, let me know please.

Just a quick update on that one. I applied the first three patches and
so far the problem did not reappear. But as I said before there is no
easy way for me to reproduce so I will continue testing.

Kind regards,
Michael
