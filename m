Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbZAJA1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbZAJA1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbZAJAZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:25:10 -0500
Received: from smtp-out.google.com ([216.239.45.13]:49643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032AbZAJAZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:25:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=UcAttCZAjC7jge+DoyzPZtBXmpl/1JAyX0eFSGNJCeL+ir7OsWK9H5O/iz5GX7Rxb
	uxwoTKHMok9yHc+eCXuQw==
MIME-Version: 1.0
In-Reply-To: <20090109161947.70f6d73d.rdunlap@xenotime.net>
References: <4966B383.3030106@cn.fujitsu.com>
	 <20090109223442.GO9737@balbir.in.ibm.com>
	 <20090109161947.70f6d73d.rdunlap@xenotime.net>
Date: Fri, 9 Jan 2009 16:25:02 -0800
Message-ID: <6599ad830901091625h7eb9d978v61f99d4afde220a1@mail.gmail.com>
Subject: Re: [PATCH] cgroups: consolidate cgroup documents
From: Paul Menage <menage@google.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: balbir@linux.vnet.ibm.com, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.141
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 4:19 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>
> I'm for that also, but I thought that cpusets existed regardless of
> cgroups/controllers.  Maybe I'm wrong?
>

Cpusets is just a client subsystem of cgroups.

Paul
