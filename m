Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYHBQxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYHBQxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 12:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYHBQxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 12:53:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41002 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754786AbYHBQxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 12:53:37 -0400
Date: Sat, 2 Aug 2008 11:53:34 -0500
From: Paul Jackson <pj@sgi.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH 2/2] cpuset: use seq_cpumask(), seq_nodemask()
Message-Id: <20080802115334.dd2732af.pj@sgi.com>
In-Reply-To: <20080802142838.GA338@martell.zuzino.mipt.ru>
References: <20080802113131.GB3536@martell.zuzino.mipt.ru>
	<20080802090542.51052006.pj@sgi.com>
	<20080802142838.GA338@martell.zuzino.mipt.ru>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey wrote:
> That's just a reminder to cpuset people whether /proc/*/status broken or
> not. Can be safely deleted. :-)

What can be safely deleted - the patch, or the comment of the patch?

I'm confused.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
