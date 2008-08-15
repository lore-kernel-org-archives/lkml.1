Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYHPAFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYHPAFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 20:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYHPAE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 20:04:58 -0400
Received: from 197.Red-80-32-81.staticIP.rima-tde.net ([80.32.81.197]:51214
	"EHLO mail.pina.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYHPAE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 20:04:58 -0400
Date: Sat, 16 Aug 2008 01:44:02 +0200
From: Carles Pina i Estany <carles@pina.cat>
To: linux-kernel@vger.kernel.org
Subject: network accounting by process
Message-ID: <20080815234402.GA8445@pina.cat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Recently I've discovered the IO Accounting (I mean, /proc/PID/io).
It's very interesting, specially together with iotop (thanks!)

I wonder: is there something in the proc fs similar for network? How
much bytes the _process_ are receiving/sending just now? I've checked
and I haven't found.

If there isn't any wat to get this information: is there any technical
problem to not have it? It looks like it would be possible to add
something similar in ipv4 level (net/ipv4/af_inet.c for example).

Thank you,

-- 
Carles Pina i Estany		GPG id: 0x17756391
	http://pinux.info
