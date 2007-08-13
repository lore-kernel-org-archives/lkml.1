Return-Path: <linux-kernel-owner+w=401wt.eu-S946790AbXHMQwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946790AbXHMQwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S948193AbXHMQVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:21:30 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48353 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S948188AbXHMQV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:21:27 -0400
Date: Mon, 13 Aug 2007 18:22:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Message-ID: <20070813162240.GA17823@uranus.ravnborg.org>
References: <1186984174.10249.7.camel@localhost> <20070813071606.GF21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813071606.GF21089@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Please, people, try to think for a minute.  Patch series are good not
> just because; there are rational reasons for that.  None of those
> applies here; if anything, you've made sure that this patchbomb will
> be less reviewed.

This huge serie had one nice property.
Relavent people got only relevant patches sent direct.
They should have been sent *only* to these people and then
with relevant modifications could have been applied as a single patch.

	Sam
