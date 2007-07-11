Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbXGKJYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbXGKJYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbXGKJX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:23:57 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33445 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755169AbXGKJX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:23:57 -0400
Date: Wed, 11 Jul 2007 02:23:52 -0700
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, menage@google.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-Id: <20070711022352.71604404.pj@sgi.com>
In-Reply-To: <20070711090423.GA6758@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710105240.GA20914@linux.vnet.ibm.com>
	<6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
	<20070710115319.0bdaff34.akpm@linux-foundation.org>
	<20070711045516.GH2927@linux.vnet.ibm.com>
	<20070710222942.382fc9ba.akpm@linux-foundation.org>
	<20070711090423.GA6758@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> another option would be to trivially hook up CONFIG_FAIR_GROUP_SCHED 
> with cpusets, ...

ah ... you triggered my procmail filter for 'cpuset' ... ;).

What would it mean to hook up CFS with cpusets?  I've a pretty
good idea what a cpuset is, but don't know what kind of purpose
you have in mind for such a hook.  Could you say a few words to
that?  Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
