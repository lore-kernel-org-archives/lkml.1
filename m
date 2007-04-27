Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbXD0GDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbXD0GDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXD0GDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:03:42 -0400
Received: from canuck.infradead.org ([209.217.80.40]:38532 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbXD0GDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:03:41 -0400
Subject: Re: [ANNOUNCE] battery2 git repository
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070427000928.GA5303@suse.de>
References: <20070426232902.GA10423@zarina>  <20070427000928.GA5303@suse.de>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 07:03:34 +0100
Message-Id: <1177653814.2755.466.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 17:09 -0700, Greg KH wrote:
> So, I'm still not quite understanding this, is David giving up on his
> code now that you have pulled his changes into your tree?  Or is there
> some reason there are still two competing versions here?

Anton hasn't pulled my changes -- it's a separate implementation,
although very similar. In return for the account on git.infradead.org he
said he was going to port the two drivers I already had (PMU and OLPC)
to his framework.

I have no particular attachment to my own version. I'm perfectly happy
just to use Anton's. Mine's still present just for reference, and hasn't
actually been touched in months -- I haven't had the time.

-- 
dwmw2

