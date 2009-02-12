Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbZBLXdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbZBLXdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZBLXde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:33:34 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:49290 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZBLXdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:33:33 -0500
X-BigFish: VPS-17(zz98dR936eQ9371Pzzzz92fbmz2fh6bh62h38m)
X-EF: str=0001.0A010206.4994B1CB.0145,ss=3,fgs=0
X-Spam-TCS-SCL: 1:0
Message-ID: <4994B1A3.8080502@am.sony.com>
Date: Thu, 12 Feb 2009 15:32:51 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
References: <20090212011051.265346435@goodmis.org>
In-Reply-To: <20090212011051.265346435@goodmis.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2009 23:32:51.0914 (UTC) FILETIME=[39004AA0:01C98D6A]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2009 05:10 PM, Steven Rostedt wrote:
> This is the port to PowerPC of the function graph tracer that was written
> by Frederic Weisbecker for the x86 architecture.  It is broken up
> into a series of logical steps.

I added these to my ps3-linux.git tree.  Very casual testing shows
they seem to work OK.


Tested-by: Geoff Levand <geoffrey.levand@am.sony.com>  Working OK on PS3.

