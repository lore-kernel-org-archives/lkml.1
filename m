Return-Path: <linux-kernel-owner+w=401wt.eu-S937440AbYEBXxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937440AbYEBXxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764497AbYEBXxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:53:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763477AbYEBXxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:53:22 -0400
Date: Fri, 2 May 2008 16:52:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
Message-Id: <20080502165248.dba934e9.akpm@linux-foundation.org>
In-Reply-To: <1209742841.12502.40.camel@odin>
References: <1209742841.12502.40.camel@odin>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 16:40:41 +0100
Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> This is an updated version of the kernel voltage & current regulator
> framework based on comments received from version 3 of the patch series.
> 
> The regulator framework is designed to provide a standard kernel
> interface to control voltage and current regulators on SoC based
> systems.
> 
> The intention is to allow systems to dynamically control regulator power
> output in order to save power and prolong battery life. This applies to
> both voltage regulators (where voltage output is controllable) and
> current sinks (where current limit is controllable).
> 

oh gee.

I (and others) reviewed and commented on all this code last month.  Now
here it is again and, although I'm sure it is delightful code, nobody wants
to have to read it all again ;)

The one-month gap between v3 and v4 is unfortunate.  It means that everyone
has forgotten everything.


Was all the review feedback satisfactorily handled to the reviewers'
satisfaction?

Is there any new material in here which would require a re-review?
