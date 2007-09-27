Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbXI0Qwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbXI0Qwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbXI0Qwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:52:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45411 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbXI0Qwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:52:34 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Sep 2007 09:52:32 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: lkml <linux-kernel@vger.kernel.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>, geoff@gclare.org.uk
Subject: Re: eventfd.2 man page
In-Reply-To: <46FB9D4B.4090909@gmx.net>
Message-ID: <Pine.LNX.4.64.0709270951000.763@alien.or.mcafeemobile.com>
References: <46FB9D4B.4090909@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Michael Kerrisk wrote:

> Hi Davide,
> 
> I've slightly tweaked the eventfd.2 man page in preparation for adding it
> to the man-pages set.  Could you please review the text below, and confirm
> that it correctly describes intended behavior.

Looks good to me. At the time that I was tsting it, I cooked an example 
about how to use an eventfd with KAIO:

http://www.xmailserver.org/eventfd-aio-test.c

In case you'd like to add a sketch to the man page.



- Davide


