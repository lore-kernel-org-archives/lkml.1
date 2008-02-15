Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbYBOK6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbYBOK6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758865AbYBOK6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:58:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43068 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757615AbYBOK6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:58:35 -0500
Date: Fri, 15 Feb 2008 04:58:29 -0600
From: Paul Jackson <pj@sgi.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: kosaki.motohiro@jp.fujitsu.com, rientjes@google.com,
       Lee.Schermerhorn@hp.com, mel@csn.ul.ie, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clameter@sgi.com
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
Message-Id: <20080215045829.36a3e0b1.pj@sgi.com>
In-Reply-To: <2c0942db0802141255o5d18c6bfxe052ba9512a18817@mail.gmail.com>
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>
	<2f11576a0802140611h261b9df2qd13406e562f52864@mail.gmail.com>
	<20080214103541.10943567.pj@sgi.com>
	<2c0942db0802141255o5d18c6bfxe052ba9512a18817@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray wrote:
> bitmap_onto?

Ah - you were the original person to propose this.  Thank-you.

> bitmap_read_my_kernel_doc?

;).

> Minor suggestion:
> + * and the n-th bit of @relmap is the m-th set bit of @relmap.

I'll ponder that confusing line - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
