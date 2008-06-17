Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYFQIUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYFQIUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 04:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYFQIUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 04:20:32 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:4949 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbYFQIUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 04:20:31 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25.7
Date: Tue, 17 Jun 2008 10:20:19 +0200
User-Agent: PLD Linux KMail/1.9.9
References: <20080616204307.GA8924@kroah.com>
In-Reply-To: <20080616204307.GA8924@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806171020.19624.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 June 2008, Greg KH wrote:
> We (the -stable team) are announcing the release of the 2.6.25.7 kernel.
>
> It contains a number of assorted bugfixes all over the tree.  Users are
> encouraged to update.
>
> I'll also be replying to this message with a copy of the patch between
> 2.6.25.6 and 2.6.25.7

ppc

  CC      drivers/macintosh/mediabay.o
drivers/macintosh/mediabay.c: In function 'check_media_bay':
drivers/macintosh/mediabay.c:427: error: 'struct media_bay_info' has no member 
named 'cd_index'
make[2]: *** [drivers/macintosh/mediabay.o] Error 1

There was a patch to fix this somewhere I think.

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
