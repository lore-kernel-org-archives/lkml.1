Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbZEHXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbZEHXQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZEHXQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:16:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbZEHXQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:16:39 -0400
Date: Fri, 8 May 2009 16:13:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, sandeen@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] fiemap tester
Message-Id: <20090508161318.c73d766c.akpm@linux-foundation.org>
In-Reply-To: <20090508191649.GG9068@unused.rdu.redhat.com>
References: <20090508191649.GG9068@unused.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009 15:16:49 -0400
Josef Bacik <josef@redhat.com> wrote:

> Here is small little program which I and Eric have been working on this week to
> better test FIEMAP

I for one wouldn't complain were someone to create
Documentation/fs/tests/ and to then start filling it with stuff.

