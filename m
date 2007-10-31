Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbXJaAEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbXJaAEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbXJaADx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:03:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54248 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759591AbXJaADv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:03:51 -0400
Date: Tue, 30 Oct 2007 17:03:49 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071030170349.11f3aa4a.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710301618590.19750@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
	<20071028164637.8d1b45b0.pj@sgi.com>
	<alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
	<20071028212745.57a7db67.pj@sgi.com>
	<alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
	<20071028224533.df924291.pj@sgi.com>
	<alpine.DEB.0.9999.0710282352270.23978@chino.kir.corp.google.com>
	<20071029002602.34866d8c.pj@sgi.com>
	<alpine.DEB.0.9999.0710301548350.15640@chino.kir.corp.google.com>
	<20071030161728.40f27300.pj@sgi.com>
	<alpine.DEB.0.9999.0710301618590.19750@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> Of course there's actual and real world examples of this, because right 
> now we're not meeting the full intent of the application.

Please describe one, an actual one, not a hypothetical one, of which you
have personal knowledge.

There are many refinements we could add, an endless stream of them.
Each one adds a burden to those who didn't need it.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
