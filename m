Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbYHOXxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbYHOXxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYHOXxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:53:03 -0400
Received: from 197.Red-80-32-81.staticIP.rima-tde.net ([80.32.81.197]:47323
	"EHLO mail.pina.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYHOXxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:53:01 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2008 19:53:01 EDT
Date: Sat, 16 Aug 2008 01:51:27 +0200
From: Carles Pina i Estany <carles@pina.cat>
To: linux-kernel@vger.kernel.org
Subject: Re: network accounting by process
Message-ID: <20080815235127.GA8733@pina.cat>
References: <20080815234402.GA8445@pina.cat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815234402.GA8445@pina.cat>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Aug/16/2008, Carles Pina i Estany wrote:

> Recently I've discovered the IO Accounting (I mean, /proc/PID/io).
> It's very interesting, specially together with iotop (thanks!)

Ops!

>From this webpage: http://lkml.org/lkml/2008/4/2/60

This is already done:
http://lkml.org/lkml/2008/4/2/60

Looks like a patch for 2.6.24.4, I will do some tests. Looks like from
April, so maybe there is more news in the list. I will check it.

-- 
Carles Pina i Estany		GPG id: 0x17756391
	http://pinux.info
