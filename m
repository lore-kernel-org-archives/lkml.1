Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbZJPO4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbZJPO4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 10:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759378AbZJPO4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 10:56:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:51198 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759312AbZJPO4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 10:56:10 -0400
Date: Fri, 16 Oct 2009 09:55:26 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       Cliff Whickman <cpw@sgi.com>
Subject: Re: [patch 0/2] x86, UV: fixups for configurations with a large
	number of nodes.
Message-ID: <20091016145526.GA8903@sgi.com>
References: <20091015223959.783988000@alcatraz.americas.sgi.com> <20091016063405.GB20388@elte.hu> <20091016112920.GZ8903@sgi.com> <20091016125313.GB15393@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016125313.GB15393@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 02:53:13PM +0200, Ingo Molnar wrote:
...
> So ... is the commit log message i've put into the commit below correct, 
> or is it still only a cleanup patch? You really need to put that kind of 
> info into your changelogs - it helps maintainers put it into the right 
> kernel release.
> 
> 	Ingo

...

> The open-coded code was wrong as well - it might explain a
> few of our unexplained bau hangs.

Terrific.  Thank you for fixing up my commit message.  I will try to be
more complete next time.

Robin
