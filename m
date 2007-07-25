Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbXGYUaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbXGYUaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXGYUa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:30:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbXGYUa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:30:28 -0400
Message-ID: <46A7B2BF.4000506@redhat.com>
Date: Wed, 25 Jul 2007 16:29:51 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hpa@zytor.com, kaos@ocs.com.au,
       xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org> <20070725171956.GF27237@ftp.linux.org.uk> <46A78B47.1070500@goop.org>
In-Reply-To: <46A78B47.1070500@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2007 01:41 PM, Jeremy Fitzhardinge wrote:
> 
> I reported it as a gcc bug, but they refused to hear of it.  Details at
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=29305
> 

Wow.

I especially like "You should plan a better way. "
