Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbXH0Lfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbXH0Lfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbXH0Lfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:35:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:54902 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbXH0Lfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rCXNfnTooX1j3XPVg423FDwVx6vXw/Odz+L9FvlKDzuY5biLGHsnkQ6J42+fvUJdEwEU6CcwsL/WF7O7qsudfYUyI0iqBqIg/Q/xJnuScfoDjibfi9LkKzV/1I/OT8EmzOgsYpONa53kPIXG6l7z7qH4YFmeD0v8QkFvMAV7upE=
Message-ID: <6bffcb0e0708270435m1554bb72k7e0c287916d0f836@mail.gmail.com>
Date: Mon, 27 Aug 2007 13:35:42 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2 regression in 2.6.21)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Walker" <dwalker@mvista.com>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <46D29C3D.5070801@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
	 <46D29C3D.5070801@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/07, Jeff Garzik <jeff@garzik.org> wrote:
> Andrew Morton wrote:
> > What I'm concerned about is that regressions which we didn't fix are just
> > getting lost.  Is anyone taking care to ensure that they are getting
> > transitioned into bugzilla for tracking?
>
> Maybe this was a dumb assumption on my part, but I thought regressions
> were getting rolled over into the next release's list, if they are not
> solved?

I have tried to track all regressions, but it is a lot of work, so I
center on development kernels.

There are two lists (both unmaintained)

http://kernelnewbies.org/known_regressions_2622
http://kernelnewbies.org/known_regressions_2621

If you compare them, you will see "New regressions (submitted after
2.6.21 a.k.a. for -stable team)" - a long list of problems reported
after 2.6.21 release. I really do not have time to track issues in
stable releases.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
