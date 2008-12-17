Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753410AbYLQOoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYLQOoH (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 09:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYLQOnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 09:43:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:1964 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYLQOnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 09:43:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q3DAd7F1zisYsDTGkoklbP3sKtYd2D6kzuPmgJulIVCdbvtofk3CpwJHjqFJq5TGw3
         xZWlCzD7P8w8l6ci2tvb8tc4+cecgepbTvb6Ub9GEhdcfv4kBfw5rK8Q8CdTnQR0slBf
         X48gV2JB+N9M21Mq/7knJYhIRRHT8PqqsJpM8=
Date: Wed, 17 Dec 2008 17:43:45 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH last/many] x86: checking framework for correct use of
	ENTRY/PROC
Message-ID: <20081217144345.GA8078@localhost>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1229505475-10219-2-git-send-email-heukelum@fastmail.fm> <1229505475-10219-3-git-send-email-heukelum@fastmail.fm> <aa79d98a0812170351rb64c595gc933456c661317c5@mail.gmail.com> <20081217120450.GA8600@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217120450.GA8600@mailshack.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Wed, Dec 17, 2008 at 01:04:50PM +0100]
...
| > Thanks Alexander!
| > 
| > You know I think you meant __ASSEMBLY__ while
| > were typing __ASSEMBLER__. Don't you? :)
| 
| If it matters there is some cleanup to do in the kernel tree ;).
| 
| Greetings,
|     Alexander
| 

I somehow missed the line the pointed to not apply this patch
that is why I was amaized since I dont remember where we use
__ASSEMBLER__. Got it :)

		- Cyrill -
