Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbZANUQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbZANUQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZANUQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:16:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbZANUQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:16:08 -0500
Date: Wed, 14 Jan 2009 12:15:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [git pull] scheduler fixes
Message-Id: <20090114121521.197dfc5e.akpm@linux-foundation.org>
In-Reply-To: <20090111144305.GA7154@elte.hu>
References: <20090111144305.GA7154@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009 15:43:05 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> Please pull the latest sched-fixes-for-linus git tree

In http://bugzilla.kernel.org/show_bug.cgi?id=12309 the reporters have
identified what appears to be a sched-related performance regression. 
A fairly long-term one - post-2.6.18, perhaps.

Testcase code has been added today.  Could someone please take a look
sometime?

