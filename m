Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYLSR0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYLSR0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYLSR0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:26:23 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37323 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYLSR0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:26:22 -0500
Date: Fri, 19 Dec 2008 18:27:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: check for extra kernel-doc notations
Message-ID: <20081219172749.GA24451@uranus.ravnborg.org>
References: <494BD09A.4020605@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494BD09A.4020605@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 08:49:30AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add functionality to check for function parameters or structure (or
> union/typedef/enum) field members that are described in kernel-doc but
> are not part of the expected (declared) parameters or structure.
> These generate warnings that are called "Excess" descriptions.

Fixed the trivial excess spaces and applied.

	Sam
