Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZCOI5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZCOI5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 04:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZCOI5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 04:57:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60145 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZCOI5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 04:57:45 -0400
Date: Sun, 15 Mar 2009 08:57:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: fix crash due to tracing of __naked functions
Message-ID: <20090315085712.GB2865@n2100.arm.linux.org.uk>
References: <1236584800-7686-1-git-send-email-u.kleine-koenig@pengutronix.de> <49BC5D8C.209@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49BC5D8C.209@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 06:44:44PM -0700, Tim Bird wrote:
> Uwe Kleine-König wrote:
> > without this change a kernel having CONFIG_FUNCTION_TRACER=y doesn't
> > boot on many maschines.  It would be great if this change would make it
> > into .29.
> 
> I'd like to ACK this patch (not sure if my opinion matters).

You're far too late, the patch has already been committed and the request
for Linus to pull it has been sent.

If you want to ack things, you need to be a little faster.
