Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZAZQ4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZAZQ4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZAZQ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:56:26 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:34147 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZAZQ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:56:25 -0500
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] Documentation: update CodingStyle tips for Emacs users
In-Reply-To: <497DE701.5050005@oracle.com> (Randy Dunlap's message of "Mon\, 26 Jan 2009 08\:38\:25 -0800")
References: <1232299115-8130-1-git-send-email-tlikonen@iki.fi>
	<87priaumal.fsf@iki.fi> <497DE701.5050005@oracle.com>
From: Teemu Likonen <tlikonen@iki.fi>
Date: Mon, 26 Jan 2009 18:56:19 +0200
Message-ID: <87skn6t39o.fsf@iki.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap (2009-01-26 08:38 -0800) wrote:

> Teemu Likonen wrote:
>>     http://article.gmane.org/gmane.linux.documentation/442

> OK, I see it.  I'm not an emacs user and I have no idea how correct
> the patch is.
>
> There is another emacs CodingStyle patch from Dan Carpenter that
> expands the "~" part of the filename to the user directory:
> see http://lkml.org/lkml/2009/1/21/62
>
> so I would be tempted to merge/apply both patches.
>
> Any other comments on these patches?

Ah, I definitely agree with Dan's change, so

    Acked-by: Teemu Likonen <tlikonen@iki.fi>

for that.

When it's applied my patch will be simpler. I'll resubmit to make your
life easier.
