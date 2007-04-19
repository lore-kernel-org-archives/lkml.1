Return-Path: <linux-kernel-owner+w=401wt.eu-S1766937AbXDSTL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766937AbXDSTL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766944AbXDSTL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:11:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:51881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766937AbXDSTL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:11:58 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Date: Thu, 19 Apr 2007 21:11:52 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704192111.52395.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We likely need actual defragmentation support.

To be honest it looks quite pointless before this is solved. So far it is
not even clear if it is feasible to solve it.

-Andi
