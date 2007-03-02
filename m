Return-Path: <linux-kernel-owner+w=401wt.eu-S2992611AbXCBQx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992611AbXCBQx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992612AbXCBQx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:53:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34364 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992611AbXCBQx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:53:28 -0500
Date: Fri, 2 Mar 2007 08:52:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kirill Korotaev <dev@openvz.org>
Cc: Paul Jackson <pj@sgi.com>, vatsa@in.ibm.com, menage@google.com,
       ebiederm@xmission.com, sam@vilain.net, xemul@sw.ru, serue@us.ibm.com,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on
 top of nsproxy!
Message-Id: <20070302085224.48212452.akpm@linux-foundation.org>
In-Reply-To: <45E84682.6040500@openvz.org>
References: <20070301133543.GK15509@in.ibm.com>
	<20070301113900.a7dace47.pj@sgi.com>
	<45E84682.6040500@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 18:45:06 +0300 Kirill Korotaev <dev@openvz.org> wrote:

> > I'm wagering you'll break either the semantics, and/or the
> > performance, of cpusets doing this.
> I like Paul's containers patch. It looks good and pretty well.
> After some of the context issues are resolved it's fine.
> Maybe it is even the best way of doing things.

Have you thought about the relationship between it and UBC?

