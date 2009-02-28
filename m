Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZB1Rjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZB1Rjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZB1Rjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:39:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:56786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZB1Rjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:39:45 -0500
Date: Sat, 28 Feb 2009 09:40:12 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@sirena.org.uk>
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090228094012.6d98ce05@infradead.org>
In-Reply-To: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk>
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 18:05:20 +0000
Mark Brown <broonie@sirena.org.uk> wrote:

> Try to help ensure that e-mailed patches have some commit log text in
> the body of the e-mail by warning if we can't find any lines that look
> like a header of some kind prior to the Signed-off-by.

maybe we should also spell check the changelog (aspell ?)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
