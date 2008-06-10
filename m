Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYFJOxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYFJOxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYFJOxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:53:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53516 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033AbYFJOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:53:31 -0400
X-Sasl-enc: pQtsbIfJwdFSz/D03LRcVvMT/rnMWCLMBO6vMru8lST8 1213109609
Date: Tue, 10 Jun 2008 11:53:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.25.6
Message-ID: <20080610145325.GC23351@khazad-dum.debian.net>
References: <20080609194924.GL30402@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609194924.GL30402@sequoia.sous-sol.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2008, Chris Wright wrote:
> We (the -stable team) are announcing the release of the 2.6.25.6 kernel.
> 
> It contains a number of assorted bugfixes all over the tree.  Users are
> encouraged to update.

It also contains at least one security bugfix, as some were quick to point
out in not-so-kind words:

http://lwn.net/Articles/285438/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
