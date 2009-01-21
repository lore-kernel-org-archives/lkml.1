Return-Path: <linux-kernel-owner+w=401wt.eu-S1763512AbZAUEYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763512AbZAUEYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 23:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZAUEYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 23:24:44 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53011 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbZAUEYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 23:24:43 -0500
Date: Wed, 21 Jan 2009 13:23:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
       roland@redhat.com, bastian@waldi.eu.org, daniel@hozac.com,
       xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][v7] Container-init signal semantics
Message-Id: <20090121132337.9ff4ed16.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <m1k58pwaxj.fsf@fess.ebiederm.org>
References: <20090117202638.GA11825@us.ibm.com>
	<20090119110906.58ccbcbd.kamezawa.hiroyu@jp.fujitsu.com>
	<20090121030500.GA32138@us.ibm.com>
	<20090121125300.b5916256.kamezawa.hiroyu@jp.fujitsu.com>
	<m1k58pwaxj.fsf@fess.ebiederm.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009 20:16:40 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
> > What makes me confused is "Container". There is no "Container" in
> > the linux kernel, just cgroup and its subsyss.
> > (Some source codes still use "cont" but new codes all use "cgroup" or "cgrp" )
> >
> > So, I asked whether "Container" means "Namespace subsys" or something different.
> 
> "Container" is what we use to refer to the user space concept, that is built
> from a set of namespaces and control groups.  A Container that looks like
> a standard linux install from the inside is what we expect the most common
> use of namespaces and control groups to be.
> 

Thank you for clarification :)

Regards,
-Kame

