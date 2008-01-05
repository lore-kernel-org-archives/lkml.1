Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbYAEJav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbYAEJav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYAEJak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:30:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181AbYAEJai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:30:38 -0500
Date: Sat, 5 Jan 2008 01:30:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Message-Id: <20080105013031.3b1bcb9f.akpm@linux-foundation.org>
In-Reply-To: <1198893445.6821.108.camel@twins>
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
	<1198891742.6821.98.camel@twins>
	<a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
	<1198892544.6821.103.camel@twins>
	<a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com>
	<1198893445.6821.108.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007 02:57:24 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> > Sorry, I don't use git tools now. Could you tell me how to fix it?
> > thanks in advance.
> 
> Just ensure that the kernel builds after each applied patch.

And that it runs ;)
