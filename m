Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbYBOKZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbYBOKZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYBOKZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:25:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42318 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757252AbYBOKZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:25:35 -0500
Date: Fri, 15 Feb 2008 04:25:28 -0600
From: Paul Jackson <pj@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: ray-lk@madrabbit.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com,
       Lee.Schermerhorn@hp.com, mel@csn.ul.ie, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clameter@sgi.com
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
Message-Id: <20080215042528.8714febd.pj@sgi.com>
In-Reply-To: <20080215092014.1C49.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080214103541.10943567.pj@sgi.com>
	<2c0942db0802141255o5d18c6bfxe052ba9512a18817@mail.gmail.com>
	<20080215092014.1C49.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kosaki-san wrote:
> I like bitmap_onto

I like it too.  And easier to type than bitmap_surjection ;).

> relmap could be sparse (which, btw, would have been nice to
> have in the example)

Good idea.

I'll see what I can cook up.

Thank-you, sir.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
