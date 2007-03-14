Return-Path: <linux-kernel-owner+w=401wt.eu-S1161205AbXCNMQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161205AbXCNMQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161196AbXCNMQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:16:50 -0400
Received: from main.gmane.org ([80.91.229.2]:33371 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161205AbXCNMQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:16:49 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Subject: Re: [Bug 8040] Hang before INIT when =?utf-8?b?Q09ORklHX0hJR0hNRU00Rz15?=
Date: Wed, 14 Mar 2007 12:16:30 +0000 (UTC)
Message-ID: <loom.20070314T131349-236@post.gmane.org>
References: <200703141013.l2EADP6c027144@fire-2.osdl.org>  <20070314041710.770708c4.akpm@linux-foundation.org> <6bffcb0e0703140430i2202f14dw1681d5c70c1d4e28@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 145.9.150.34 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20060601 Firefox/2.0.0.2 (Ubuntu-edgy))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > None whatsoever.  Three people are reporting this and it's a drop-dead
> > showstopper for a 2.6.21 release so we just have to wait until someone
> > wakes up and thinks about it.

The topic should be "when CONFIG_HIGHMEM64G=y" imo.

I'll try to do my first bi-sect today.

--
Leroy

