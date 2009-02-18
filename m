Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZBRKYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZBRKYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZBRKYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:24:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:4253 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbZBRKYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:24:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,228,1233561600"; 
   d="scan'208";a="111798191"
Subject: Re: [PATCH -mm] documentation: update CodingStyle tips for Emacs
	users
From: Patrick Ohly <patrick.ohly@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090218095931.GA2054@cmpxchg.org>
References: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan>
	 <1234948770.23768.25.camel@ecld0pohly>  <20090218095931.GA2054@cmpxchg.org>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 11:23:59 +0100
Message-Id: <1234952639.23768.32.camel@ecld0pohly>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 09:59 +0000, Johannes Weiner wrote:
[formatting of line continuation in argument list]
> Unfortunately, this seems to depend on the maintainer.  Both styles
> are used all over the kernel but Documentation/CodingStyle and
> scripts/checkpatch.pl prefer what the above emacs configuration does.

checkpatch.pl didn't seem to mind either way. I haven't seen this
particular aspect mentioned in the CodingStyle either.

> I doubt that people do tab tab tab space space space space space by
> hand, so I strongly suspect that the tab-only zealots don't use emacs
> which does this adjustment automatically.
> 
> You should probably add linux-davem to the above or something.  Or
> name the coding style after the text-editor the target maintainer
> uses :-)

One could also get really fancy and extend the path matching to pick the
right style depending on the subdirectory ;-)

Thanks for the clarification. In the future I'll pay closer attention to
existing code and turn the macro on or off accordingly.

-- 
Best Regards, Patrick Ohly

The content of this message is my personal opinion only and although
I am an employee of Intel, the statements I make here in no way
represent Intel's position on the issue, nor am I authorized to speak
on behalf of Intel on this matter.

