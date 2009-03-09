Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZCIOUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZCIOUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZCIOUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:20:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZCIOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:20:07 -0400
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Newall <davidn@davidnewall.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Willy Tarreau <w@1wt.eu>
In-Reply-To: <49B52118.7010509@davidnewall.com>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
	 <20090309080714.GB24904@elte.hu>  <1236596664.8389.331.camel@laptop>
	 <1236604563.6027.8.camel@marge.simson.net>
	 <1236605267.8389.490.camel@laptop>  <49B52118.7010509@davidnewall.com>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 15:19:50 +0100
Message-Id: <1236608390.8389.557.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 00:30 +1030, David Newall wrote:
> Peter Zijlstra wrote:
> > Does it actually solve the reported problem? I've only thought about the
> > issue so far
> 
> Wasn't it reported to be caused by an off-by-one bug in commit 
> 38736f475071b80b66be28af7b44c854073699cc?

Completely different issue. Unfortunate interference of effects though.


