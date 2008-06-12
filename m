Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYFLXzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYFLXzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760345AbYFLXzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:55:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:63383 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772AbYFLXzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:55:08 -0400
Subject: Re: 2.6.26-rc5-mm3
From: Daniel Walker <dwalker@mvista.com>
To: Byron Bradley <byron.bbradley@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Hua Zhong <hzhong@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.1.00.0806130006490.14928@gamma>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	 <alpine.DEB.1.00.0806130006490.14928@gamma>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 16:55:06 -0700
Message-Id: <1213314906.16459.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-13 at 00:32 +0100, Byron Bradley wrote:
> Looks like x86 and ARM both fail to boot if PROFILE_LIKELY, FTRACE and 
> DYNAMIC_FTRACE are selected. If any one of those three are disabled it 
> boots (or fails in some other way which I'm looking at now). The serial 
> console output from both machines when they fail to boot is below, let me 
> know if there is any other information I can provide.

Did you happen to check PROFILE_LIKELY and FTRACE alone?

Daniel

