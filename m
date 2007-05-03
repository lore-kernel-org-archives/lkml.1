Return-Path: <linux-kernel-owner+w=401wt.eu-S1030358AbXECIwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbXECIwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030490AbXECIwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:52:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50064 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030358AbXECIwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:52:20 -0400
Date: Thu, 3 May 2007 01:52:18 -0700
From: Paul Jackson <pj@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, rientjes@google.com,
       clameter@cthulhu.engr.sgi.com, menage@google.com
Subject: Re: + cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
 added to -mm tree
Message-Id: <20070503015218.8519a894.pj@sgi.com>
In-Reply-To: <200705030820.l438Kwqc007978@shell0.pdx.osdl.net>
References: <200705030820.l438Kwqc007978@shell0.pdx.osdl.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Paul Jackson <pj@sgi.com>

(and I retract my NAQ of the base patch preceeding this one,
as this follow-on patch addresses my concerns.)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
