Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbYJVH5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbYJVH5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYJVH4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:56:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:38284 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYJVH4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:56:53 -0400
Subject: Re: sched: add CONFIG_SMP consistency
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, henrik@austad.us,
       linux-kernel@vger.kernel.org, Henrik Austad <henrik.austad@gmail.com>
In-Reply-To: <20081022073640.GA31633@elte.hu>
References: <1224614719-14452-1-git-send-email-henrik@austad.us>
	 <1224615681.661.3.camel@twins> <48FED566.7020907@cn.fujitsu.com>
	 <20081022073640.GA31633@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Oct 2008 09:56:47 +0200
Message-Id: <1224662207.6724.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 09:36 +0200, Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > How about the following patch?
> 
> i've applied it in the form below. Peter, does it look good to you too?

yeah,. looks good, thanks guys!
