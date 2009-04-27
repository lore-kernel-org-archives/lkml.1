Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZD0ODZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZD0ODZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZD0ODQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:03:16 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:34161 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbZD0ODQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:03:16 -0400
Date: Mon, 27 Apr 2009 09:52:46 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [rfc] built-in native compiler for Linux?
In-Reply-To: <m163gtxle9.fsf@fess.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0904270950580.16119@qirst.com>
References: <20090422085828.GA16917@elte.hu> <alpine.DEB.1.10.0904241429450.19686@qirst.com> <20090424.222952.83381016.davem@davemloft.net> <m163gtxle9.fsf@fess.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009, Eric W. Biederman wrote:

> If this was about teaching sparse to run lockdep at compile time, or
> generally about making the kernel compilation much faster and able to
> catch many more bugs there might be a point where the effort is worth
> the investment.

The preprocessor and its interaction with regular C code is quite
nasty. If sparse could get rid of the complexities and idiosyncrasies at
that level then it may be useful as a "pre" compiler.

