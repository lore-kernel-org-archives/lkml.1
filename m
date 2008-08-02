Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbYHBOFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbYHBOFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 10:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYHBOFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 10:05:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39333 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752215AbYHBOFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 10:05:44 -0400
Date: Sat, 2 Aug 2008 09:05:42 -0500
From: Paul Jackson <pj@sgi.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 2/2] cpuset: use seq_cpumask(), seq_nodemask()
Message-Id: <20080802090542.51052006.pj@sgi.com>
In-Reply-To: <20080802113131.GB3536@martell.zuzino.mipt.ru>
References: <20080802113131.GB3536@martell.zuzino.mipt.ru>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey wrote:
> Folks might want to boot with NR_CPUS=4096 and see what happens,
> m->count games don't look promising. :-)

That comment is rather heavily dependent on the context of both:
 1) the previous patch comment, and
 2) booting and seeing.

Could you rewrite it, so that it doesn't depend on such context,
and can be read and understood, by itself?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
