Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYHHKeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYHHKeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYHHKen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:34:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40938 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbYHHKem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:34:42 -0400
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Amanda McPherson <amanda@amcpherson.com>, Jiri Kosina <jkosina@suse.cz>,
       Roland Dreier <rdreier@cisco.com>, Alex Chiang <achiang@hp.com>,
       =?utf-8?Q?Jochen_Vo=C3=9F?= <jochen.voss@googlemail.com>
Subject: Re: [PATCH] A development process document, V2
From: Andi Kleen <andi@firstfloor.org>
References: <20080731111443.2179bf4c@bike.lwn.net>
Date: Fri, 08 Aug 2008 12:34:37 +0200
In-Reply-To: <20080731111443.2179bf4c@bike.lwn.net> (Jonathan Corbet's message of "Thu, 31 Jul 2008 11:14:43 -0600")
Message-ID: <87y7374wxu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> writes:

> Here is an updated version of the development process document;
> hopefully I've done a reasonable job of addressing everybody's
> comments.  Please let me know if you find anything else in need of
> attention.

FWIW I wrote a paper/presentation for this years OLS with many 
similar recommendations. The main focus was on strategies for
getting difficult patches in, but it also covered many basics.

http://halobates.de/on-submitting-patches.pdf
http://halobates.de/on-submitting-patches-pres.pdf

If there's interest material from the paper could be reused
or put into Documentation.

-Andi
