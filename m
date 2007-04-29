Return-Path: <linux-kernel-owner+w=401wt.eu-S1030307AbXD2IYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307AbXD2IYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXD2IYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:24:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40002 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030420AbXD2IYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:24:12 -0400
Date: Sun, 29 Apr 2007 01:24:10 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: bad_page from quicklist patches
Message-Id: <20070429012410.b135e03d.pj@sgi.com>
In-Reply-To: <20070429012202.b0c11d4f.akpm@linux-foundation.org>
References: <20070429081610.5469.36016.sendpatchset@v0>
	<20070429012202.b0c11d4f.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That should have been fixed in -mm2, by the below:

Ah - ok - you're quick - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
