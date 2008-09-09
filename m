Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYIIQ3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYIIQ3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbYIIQ3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:29:35 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39531 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbYIIQ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:29:34 -0400
X-Sasl-enc: 4JBWiBk4zTOwc5AdB3MwovrRG/Dd8KkWHbyC7f0PzJYa 1220977773
Message-ID: <48C6A469.30702@fastmail.fm>
Date: Tue, 09 Sep 2008 18:29:29 +0200
From: Michael J Gruber <michaeljgruber+gmane@fastmail.fm>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: Bert Wesarg <bert.wesarg@googlemail.com>,
       "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       Git Mailing List <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       guilt@lists.josefsipek.net, Brandon Philips <brandon@ifup.org>
Subject: Re: [ANNOUNCE] Guilt v0.31
References: <20080908135244.GB27550@josefsipek.net> <36ca99e90809081133s58e3d32h8b85804f5bb76902@mail.gmail.com> <20080908184322.GE27550@josefsipek.net> <36ca99e90809081150v4ad6e7a0n72b5cca39e02b1bc@mail.gmail.com> <7vmyiifnwa.fsf@gitster.siamese.dyndns.org> <48C64B8B.5000606@fastmail.fm> <48C673CF.2000107@fastmail.fm> <7vd4jd8i9b.fsf@gitster.siamese.dyndns.org> <48C698DF.7010401@fastmail.fm> <7vtzcp71el.fsf@gitster.siamese.dyndns.org>
In-Reply-To: <7vtzcp71el.fsf@gitster.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano venit, vidit, dixit 09.09.2008 18:02:
> Michael J Gruber <michaeljgruber+gmane@fastmail.fm> writes:
> 
>> I keep hearing this argument, and I'm even more surprised to hear it
>> right after a major release. If not now then when's a good time for
>> cleaning up confusing inconsistencies?
> 
> Actually, after a major release is the worst time to push for such an
> agenda.

For many projects, things become unstable after a major release. This is
the time to experiment. Right before a major release, everything needs
to settle down, with a focus on bugfixes and stability.

That said, I know the "logic" of the make targets now, so I really don't
care any more what they are named. I just meant to keep others from
being confused. So I guess I'll go with the existing naming and fit
quick-install-html right in. Will go into a new thread tomorrow or so.

> Especially when that release burned the maintainer with numerous complains
> against a major change in it, that has been advertised for a long time,
> which was pushed by other people for no good reason other than "such a
> clean-up would make things much tidier".
> 
> Grrr ;-).

Junio,
I think you handled that in the best possible way, and I felt
sympathetic with you when that thread with a RFC went OT back to
discussing things over again.

Cheers,
Michael
