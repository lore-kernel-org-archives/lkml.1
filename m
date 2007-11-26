Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbXKZBZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbXKZBZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 20:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbXKZBZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 20:25:47 -0500
Received: from ozlabs.org ([203.10.76.45]:41763 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbXKZBZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 20:25:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Mon, 26 Nov 2007 12:25:44 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20071122343.446909000@suse.de> <200711231129.25982.rusty@rustcorp.com.au> <adaprxyrrv0.fsf@cisco.com>
In-Reply-To: <adaprxyrrv0.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711261225.44415.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 November 2007 07:29:39 Roland Dreier wrote:
>  > Yes, and if a symbol is already used by multiple modules, it's
>  > generically useful.  And if so, why restrict it to in-tree modules?
>
> I agree that we shouldn't make things too hard for out-of-tree
> modules, but I disagree with your first statement: there clearly is a
> large class of symbols that are used by multiple modules but which are
> not generically useful -- they are only useful by a certain small class
> of modules.

If it is so clear, you should be able to easily provide examples?

Rusty.

