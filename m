Return-Path: <linux-kernel-owner+w=401wt.eu-S934410AbXK3Bsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410AbXK3Bsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763793AbXK3Bs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:48:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49784 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763761AbXK3BsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:48:25 -0500
Date: Fri, 30 Nov 2007 01:48:11 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Justin Banks <justinb@bakbone.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jon Masters <jonathan@jonmasters.org>,
       Ray Lee <ray-lk@madrabbit.org>, tvrtko.ursulin@sophos.com,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: Out of tree module using LSM
Message-ID: <20071130014811.GA8181@ftp.linux.org.uk>
References: <1196365551.6473.103.camel@perihelion> <20071129214527.1d62056c@the-village.bc.nu> <20071129221238.GF5601@bleen.corp.bb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129221238.GF5601@bleen.corp.bb>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 03:12:38PM -0700, Justin Banks wrote:

> It's not perfect, but as was recently pointed out, if you can only get
> 98% of the way there rather than 100% is that a reason for not trying to
> make it possible?

BTW, that's a fine example of a common fallacy: "$FOO is 98% of the way to
$TARGET" does not allow to interpolate the properties of $TARGET to those
of $FOO.

Telling that a condom is a 98% approximation to platonic ideal of such is
not particulary useful, especially if it turns out that what this number 
really means is that there's a hole on its tip covering 2% of surface...
