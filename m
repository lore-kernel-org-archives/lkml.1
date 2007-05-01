Return-Path: <linux-kernel-owner+w=401wt.eu-S1030484AbXEADvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484AbXEADvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbXEADvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:51:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:62739 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXEADvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:51:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Wr4WgnRz3Wa7Zw2uMgnC/YMKiY5yaf9oqBrbm/THTLlfFmxMdWu0uNHOQkM5AE3nbyJuKoFgItBA7K+EkGweJbsSXPCeI2wkMeYynjbnOX1aR964n+/L0on7srxgSLUCb0u5IgK6x4E7QzqAc+fPjpzWcMhY2+9GpcxxMQEmebM=
Date: Tue, 1 May 2007 11:56:16 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
Message-ID: <20070501035616.GB2582@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linus Torvalds <torvalds@osdl.org>
References: <463698D5.20102@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463698D5.20102@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 06:33:09PM -0700, H. Peter Anvin wrote:
>Hi all,
>
>I'm rewriting the i386 setup code in C, instead of assembly, and before
>I spend a very large amount of time translating all the various
>card-specific probes, I want to ask the following question...
>
>Does *anyone* care about these anymore?

I think this is a good work, but it is not easy.
Hope you can do that well. ;)

