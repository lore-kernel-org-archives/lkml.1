Return-Path: <linux-kernel-owner+w=401wt.eu-S1751335AbZIKEJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbZIKEJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 00:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZIKEJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 00:09:00 -0400
Received: from mail-yx0-f176.google.com ([209.85.210.176]:45448 "EHLO
	mail-yx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZIKEI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 00:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QoG53KpnOd+oY2cnOFJmHfDtn924Wq3y49zzmi5cHYZKRz5Qo7zu8+dwfPUmRdBXKi
         uVwahl05bn2vOnlOi8rRXN57ixg5/ykN2fQ/43Px/5yXOCq8NubMPvTPxpofAvTz2hLP
         r/6euTlZocOz1Ld07boOuO32SPv13u19N9e+A=
Subject: Re: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
From: Tom Zanussi <tzanussi@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090910160106.316cf8fb.randy.dunlap@oracle.com>
References: <4AA4C04D.1050201@cn.fujitsu.com>
	 <4AA4C0B3.3070300@cn.fujitsu.com> <1252341871.7959.37.camel@laptop>
	 <20090907164852.GA6485@elte.hu> <1252342545.7959.42.camel@laptop>
	 <1252393315.10919.4.camel@tropicana>
	 <20090910160106.316cf8fb.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 23:08:58 -0500
Message-Id: <1252642138.8016.4.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 16:01 -0700, Randy Dunlap wrote:
> On Tue, 08 Sep 2009 02:01:55 -0500 Tom Zanussi wrote:
> 
> > I've been meaning to write up something about the event filters - here's
> > a first stab that hopefully helps explain them...
> > 
> > Tom
> 
> Hi Tom,
> 
> Pretty good info.  Thanks.
> Just a few small comments & question(s):
> 

Thanks, Randy.  I'll make those changes in the next version...

Tom

