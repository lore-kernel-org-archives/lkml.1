Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbYBLSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbYBLSLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762862AbYBLSLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:11:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58944 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760646AbYBLSLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:11:30 -0500
Message-ID: <47B1E14E.2010207@garzik.org>
Date: Tue, 12 Feb 2008 13:11:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org> <20080212170422.GE3051@tuxdriver.com>
In-Reply-To: <20080212170422.GE3051@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> FWIW, I definitely have a (vocal minority) group of contributors
> who resent all the rebasing.  There may be a few cases of 'vanity'
> represented here, but there are definitely reasonable complaints about
> not being able to do simple pulls to stay up-to-date and/or having
> to rebase before they can send patches to me.  FWIW, I think it might
> save a bit of my time as well, although I have become pretty good and
> "riding the tide" of rebasing... :-(


Definitely...  that is the sort of stuff that upstream folks never see 
when they rebase -- it causes an explosion of downstream rebasing, where 
each rebase must wait for the one-step-up upstream to rebase, before 
patches can be sent.  It's easy for the rebasing to get exponential 
quickly, the more downstream levels you have.

	Jeff



