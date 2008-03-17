Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYCQDLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYCQDLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 23:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYCQDLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 23:11:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43053 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752072AbYCQDLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 23:11:36 -0400
Date: Sun, 16 Mar 2008 22:11:32 -0500
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [0/18] GB pages hugetlb support
Message-Id: <20080316221132.7218743e.pj@sgi.com>
In-Reply-To: <20080317258.659191058@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

Are all the "interesting" cpuset related changes in patch:

  [PATCH] [1/18] Convert hugeltlb.c over to pass global state around in a structure

?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
