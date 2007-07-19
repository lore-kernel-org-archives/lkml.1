Return-Path: <linux-kernel-owner+w=401wt.eu-S941077AbXGSSCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941077AbXGSSCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765363AbXGSSBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:01:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48851 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764017AbXGSSBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:01:52 -0400
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
From: Arjan van de Ven <arjan@infradead.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Christian Ehrhardt <lk@c--e.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
In-Reply-To: <20070719171913.GA1275@sergelap.austin.ibm.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei>
	 <20070718183503.541026f8.akpm@linux-foundation.org>
	 <20070719073948.GI18840@lisa.in-ulm.de>
	 <20070719122424.GA5186@vino.hallyn.com>
	 <1184864070.2694.3.camel@laptopd505.fenrus.org>
	 <20070719171913.GA1275@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 19 Jul 2007 11:00:21 -0700
Message-Id: <1184868021.2694.6.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> :)
> 
> Actually, given that when lsm was being introduced, lsm seemed to
> improve performance overall, have you taken any measurements to show
> that this is actually the case?  Of course it makes sense that it would,
> but witjout measurements we do not know.

SuSE did a bunch of measurement I think a year ago and they showed a
several percent performance increase with a hack similar to the proposed
next step..

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

