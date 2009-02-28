Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZB1Rrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZB1Rrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZB1Rrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:47:37 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1220 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbZB1Rrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:47:36 -0500
Date: Sat, 28 Feb 2009 17:47:22 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Message-ID: <20090228174721.GA4814@sirena.org.uk>
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <20090228094012.6d98ce05@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228094012.6d98ce05@infradead.org>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 09:40:12AM -0800, Arjan van de Ven wrote:
> Mark Brown <broonie@sirena.org.uk> wrote:

> > Try to help ensure that e-mailed patches have some commit log text in
> > the body of the e-mail by warning if we can't find any lines that look
> > like a header of some kind prior to the Signed-off-by.

> maybe we should also spell check the changelog (aspell ?)

I'd expect that'd lead to a lot of false positives on names and
technical terms, wouldn't it?
