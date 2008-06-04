Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbYFDEBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbYFDEBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbYFDEAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:00:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbYFDEAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:00:53 -0400
Date: Tue, 3 Jun 2008 21:00:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: miaox@cn.fujitsu.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: Re: [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
Message-Id: <20080603210038.51aabd12.akpm@linux-foundation.org>
In-Reply-To: <20080603215917.7fd5af63.pj@sgi.com>
References: <4843AFC9.7000100@cn.fujitsu.com>
	<20080603150346.4611b5ab.akpm@linux-foundation.org>
	<4845E80F.5000808@cn.fujitsu.com>
	<4845F742.2070301@cn.fujitsu.com>
	<20080603191108.1c35d3c5.akpm@linux-foundation.org>
	<20080603215917.7fd5af63.pj@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 21:59:17 -0500 Paul Jackson <pj@sgi.com> wrote:

> Andrew wrote:
> > I already did that, didn't I?
> 
> Where can I find your attempted merge, Andrew?
> 
> Probably someplace I should know about ... sorry.
> 

Who are you and what do you have to do with cpusets?

Sigh, sorry.  I need to drop and redo them anyway.
