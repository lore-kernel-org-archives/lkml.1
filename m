Return-Path: <linux-kernel-owner+w=401wt.eu-S1763113AbYDQI60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763113AbYDQI60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbYDQI6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:58:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762110AbYDQI6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:58:01 -0400
Date: Thu, 17 Apr 2008 01:56:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417015657.728a6d1a.akpm@linux-foundation.org>
In-Reply-To: <20080417015425.312d34c0.akpm@linux-foundation.org>
References: <20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417.014534.258800340.davem@davemloft.net>
	<20080417015425.312d34c0.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 01:54:25 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> But linux-next integrates only the
> other subsystem trees and they have rarely caused me integration problems
> against git-net.  

Well.  git-lblnet was a big problem but it was a once off.

git-wireless used to cause problems but that's now merging into git-net
more often.

git-netdev-all was sometimes a problem but that's gone altogether.

So git-net integration because much simpler during 2.6.25-rcX.
