Return-Path: <linux-kernel-owner+w=401wt.eu-S964793AbXHXCR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbXHXCR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 22:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765620AbXHXCRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 22:17:50 -0400
Received: from paragon.brong.net ([74.52.187.94]:41953 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765596AbXHXCRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 22:17:49 -0400
X-Greylist: delayed 2065 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 22:17:49 EDT
Date: Fri, 24 Aug 2007 11:43:20 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Scott Thompson <postfail@hushmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: Ideas on column length in kernel "problem"?
Message-ID: <20070824014320.GA18488@brong.net>
References: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:54:41PM -0400, Scott Thompson wrote:
> Many free (and not-free) mail clients wordwrap.  Hushmail wraps at 
> 68 (verified), Yahoo has options to wrap at a max of 99, and Gmail 
> was somewhere around 85-90 as I recall.  Not sure on other free / 
> inexpensive clients.  

<disclaimer>I work for them</disclaimer>

FastMail (http://fastmail.fm/) have a tickbox in the web interface
so you can turn off line-wrapping if you need to.
 
Otherwise, as other people have said, use direct SMTP (we don't allow
it for non-paying accounts, but do for all levels of paying user)
and use a sane local client (in my case mutt+offlineimap)

Bron.
