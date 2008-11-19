Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYKSAEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYKSAEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYKSAEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:04:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:30483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYKSAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:04:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EuoA4RerOhvMOHUuC0rTMXJ93sXLbfDva8xmk+el3GzUkRV3MsD8a1fWxerD4KupuS
         U3i7chsRz8kz1niUzEsr+Cz7mlbezylfIy1s2V2U/cb8Hj8Z2DFKwhf2Ya4Xa7zikypq
         fCZyRWigrpU9Vqr29LJnKusJnq0ypeb3j8/So=
Date: Wed, 19 Nov 2008 03:07:49 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, containers@lists.osdl.org
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task
	directories
Message-ID: <20081119000749.GA2912@x200.localdomain>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org> <m1abcd2kqk.fsf@frodo.ebiederm.org> <20081106172617.dd51d0af.akpm@linux-foundation.org> <m1abccxpc5.fsf@frodo.ebiederm.org> <20081106184945.179c248a.akpm@linux-foundation.org> <m1iqr0urb8.fsf@frodo.ebiederm.org> <20081106202822.a1af8a6e.akpm@linux-foundation.org> <m1d4h7v8jf.fsf@frodo.ebiederm.org> <20081107080529.6f4de3ad.akpm@linux-foundation.org> <m1zlk3kxfj.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlk3kxfj.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 03:39:44PM -0800, Eric W. Biederman wrote:
> On this patchset it looks like the conversation has wound down with no
> real objects except that some very simple pieces of the code appear
> magic.
> 
> 
> What looks to be the best path for getting this set of patches merged
> into /proc?

Al's ACK minimum.

> Alexy will you pick this up in your /proc tree as Andrew suggested?

Yep, doing it right now.

> Do I need to keep my own tree?

No need.

> Can I have some clear guidance on which hurdles to jump through to
> make forward progress?
