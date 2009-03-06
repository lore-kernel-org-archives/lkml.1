Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZCFTZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZCFTZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZCFTZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:25:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbZCFTZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:25:22 -0500
Date: Fri, 6 Mar 2009 11:24:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: Tree for March 6
Message-Id: <20090306112450.12901a19.akpm@linux-foundation.org>
In-Reply-To: <20090306191311.697e7b97.sfr@canb.auug.org.au>
References: <20090306191311.697e7b97.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 19:13:11 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Dropped trees (temporary):
> 	rr (build problem)

It's quite irritating and somewhat risky when this happens.  It means
that I have to teporarily drop or rework patches to fix things up. 
Then the patch needs to be undropped or unreworked when the offending
tree gets restored.

Is it possible to just drop back to the previous day's version when
something gets screwed up?

