Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbXISSGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbXISSGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXISSGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:06:43 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53489 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbXISSGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:06:43 -0400
Date: Wed, 19 Sep 2007 14:05:44 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Philipp Marek <philipp@marek.priv.at>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: UML dead with current -git?
Message-ID: <20070919180544.GA11860@c2.user-mode-linux.org>
References: <200709181714.34035@x5> <200709191443.24158@x5> <20070919085032.dd5c1732.randy.dunlap@oracle.com> <200709191817.51921@x5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709191817.51921@x5>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 06:17:51PM +0200, Philipp Marek wrote:
> How about that?
> 	readlink include/asm
> returns
> 	asm-um
> in my case, so I only have to strip the "asm-" part ...

It doesn't handle O= directories...

				Jeff

-- 
Work email - jdike at linux dot intel dot com
