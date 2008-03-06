Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbYCFO5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbYCFO5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbYCFO5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:57:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37701 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538AbYCFO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:57:16 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
From: David Woodhouse <dwmw2@infradead.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Roskin <proski@gnu.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <47C838C5.8030707@nortel.com>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <47C838C5.8030707@nortel.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 14:56:34 +0000
Message-Id: <1204815394.3117.6.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 (2.21.92-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 10:54 -0600, Chris Friesen wrote:
> But the GPL only applies to derivative works. 

Not entirely true -- or at least somewhat misleading as phrased.

There are cases where the GPL clearly states that it _does_ apply to
sections of code which are "independent and separate works in
themselves".

-- 
dwmw2

