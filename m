Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbXDPQoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbXDPQoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXDPQoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:44:30 -0400
Received: from ns.suse.de ([195.135.220.2]:52495 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbXDPQo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:44:29 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [nameidata 2/2] Pass no useless nameidata to the create, lookup, and permission IOPs
Date: Mon, 16 Apr 2007 18:44:38 +0200
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <200704161829.20669.agruen@suse.de> <20070416094225.2616c4b6.randy.dunlap@oracle.com>
In-Reply-To: <20070416094225.2616c4b6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161844.39007.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 18:42, Randy Dunlap wrote:
> Please don't use the kernel-doc begin-marker "/**" when the comment block
> isn't in kernel-doc format.

Sigh, kernel-doc should improve things, not get in the way ...
