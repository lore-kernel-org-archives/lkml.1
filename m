Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbYG2NFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbYG2NFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYG2NFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:05:46 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47150 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751529AbYG2NFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:05:45 -0400
Date: Tue, 29 Jul 2008 08:05:43 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpuset: fix wrong calculation of relax domain level
Message-Id: <20080729080543.67575625.pj@sgi.com>
In-Reply-To: <488E7D92.8020501@cn.fujitsu.com>
References: <488D3331.8000306@cn.fujitsu.com>
	<20080728001530.bf7f5e44.pj@sgi.com>
	<488E7D92.8020501@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan, replying to pj:
> > ... However, I'm too lazy to propose a patch to mess with this.
> > 
> 
> But it doesn't bother me. ;)
> 
> IMO it's not good to mess things up by sending a patch to just rename all

Agreed - guess that 'attr' stuff will remain as it be for now.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
