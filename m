Return-Path: <linux-kernel-owner+w=401wt.eu-S1764710AbXGZKOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764710AbXGZKOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbXGZKOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:14:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbXGZKOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:14:22 -0400
Date: Thu, 26 Jul 2007 03:14:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: "Masoud Sharbiani" <masouds@google.com>,
       "Kirill Korotaev" <dev@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
Message-Id: <20070726031406.3866ddc5.akpm@linux-foundation.org>
In-Reply-To: <200707261146.23886.ak@suse.de>
References: <20070718154759.GA26425@google.com>
	<4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>
	<20070725162528.7d485ff8.akpm@linux-foundation.org>
	<200707261146.23886.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 11:46:23 +0200 Andi Kleen <ak@suse.de> wrote:

> 
> > Look: if there's a way in which an unprivileged user can trigger a printk
> > we fix it, end of story. 
> 
> I'm firmly against disabling it on x86-64 by default.

We know you are, and the consensus and past practice disagree with you, as
you well know.

> The printks are extremly
> useful and have found many bugs in the past.

So you turn it on if your applications are playing up.  bfd.


Still waiting for your report of all the other means by which unpriviliged
users can spam the logs, btw.  Of course, your attitude here makes a
mockery of all our other care and effort in this area.

