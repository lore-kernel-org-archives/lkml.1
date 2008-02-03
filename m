Return-Path: <linux-kernel-owner+w=401wt.eu-S936269AbYBCGSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936269AbYBCGSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYBCGS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:18:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393AbYBCGSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:18:25 -0500
Date: Sat, 2 Feb 2008 22:18:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
Message-Id: <20080202221812.2f9d70a8.akpm@linux-foundation.org>
In-Reply-To: <47A558CF.60702@kernel.org>
References: <47A2D439.9050704@kernel.org>
	<20080201002837.d84fc029.akpm@linux-foundation.org>
	<47A558CF.60702@kernel.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Feb 2008 22:01:51 -0800 "Andrew G. Morgan" <morgan@kernel.org> wrote:

> Here is the very very long version (which took some time to write, and I
> thought was a bit much to spam these lists with):
> 
> http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html

Thanks.  Imagine not testing the retrn value from something like setuid().
Oh well.  The reasoning for disabling it was good.

So how do we ever get to the stage where we can recommend that distributors
turn these things on, and have them agree with us?

Do we have sufficiently stern things in place to prevent them from turning
it on by accident?  Some of them are pretty gung-ho.
