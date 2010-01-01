Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178Ab0AAWVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0AAWVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 17:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800Ab0AAWVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 17:21:50 -0500
Received: from www84.your-server.de ([213.133.104.84]:39000 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0AAWVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 17:21:50 -0500
Subject: Re: [PATCH] proc: revert to show stack information in
 /proc/{pid}/status
From: Stefani Seibold <stefani@seibold.net>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100101220529.GL4620@const>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
	 <1262274494.14143.7.camel@wall-e>
	 <20100101155630.1A1E.A69D9226@jp.fujitsu.com>
	 <1262358616.11460.18.camel@wall-e>  <20100101220529.GL4620@const>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jan 2010 23:21:30 +0100
Message-ID: <1262384490.16706.4.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 01.01.2010, 23:05 +0100 schrieb Samuel Thibault:
> Stefani Seibold, le Fri 01 Jan 2010 16:10:16 +0100, a écrit :
> > But ps is not a performance critical application nor a cat
> > /proc/*/status!
> 
> Errr, maybe not so much as some other operations, but a lot of tools use
> them, so it's really worth considering it.
> 

Right. And i am still trying to find some optimization. Stay tuned.

Stefani


