Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbXDZVvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbXDZVvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbXDZVvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:51:32 -0400
Received: from khc.piap.pl ([195.187.100.11]:43398 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbXDZVvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:51:31 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Rene Herman <rene.herman@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
	<462CA764.5080401@gmail.com>
	<20070425181856.42fcfeb4.akpm@linux-foundation.org>
	<463081E5.5010306@gmail.com> <20070426135426.GM3468@stusta.de>
	<20070426084143.1d973c71.randy.dunlap@oracle.com>
	<20070426155205.GN3468@stusta.de> <m38xcfhqp4.fsf@maximus.localdomain>
	<20070426194316.GY3468@stusta.de> <m3ps5qhpk4.fsf@maximus.localdomain>
	<20070426202436.GZ3468@stusta.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 26 Apr 2007 23:51:29 +0200
In-Reply-To: <20070426202436.GZ3468@stusta.de> (Adrian Bunk's message of "Thu, 26 Apr 2007 22:24:36 +0200")
Message-ID: <m3wszyst26.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> The problem with such a database would be the same as with the 
> MAINTAINERS file: The information becomes outdated, and someone has to 
> maintain it.

Sure, I can easily grep .../linux-current/MAINTAINERS. But I think the
whole problem is with people who don't have current sources.
-- 
Krzysztof Halasa
