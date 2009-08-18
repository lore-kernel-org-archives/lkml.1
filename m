Return-Path: <linux-kernel-owner+w=401wt.eu-S1751268AbZHRVeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbZHRVeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZHRVeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:34:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbZHRVeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:34:23 -0400
Date: Tue, 18 Aug 2009 14:33:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Blum <bblum@google.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       serue@us.ibm.com, lizf@cn.fujitsu.com, menage@google.com,
       bblum@google.com
Subject: Re: [PATCH v3 0/7] CGroups: cgroup memberlist enhancement+fix
Message-Id: <20090818143358.9cc9aff3.akpm@linux-foundation.org>
In-Reply-To: <20090811004737.21950.29188.stgit@hastromil.mtv.corp.google.com>
References: <20090811004737.21950.29188.stgit@hastromil.mtv.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 17:57:30 -0700
Ben Blum <bblum@google.com> wrote:

> The following series adds a "cgroup.procs" file to each cgroup that reports
> unique tgids rather than pids, which can also be written to for moving all
> threads in a threadgroup at once.

Well that didn't get much of a response, did it.

Any acks, nacks or quacks from the cgroups guys, please?
