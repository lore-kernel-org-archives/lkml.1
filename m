Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYCQIJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYCQIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYCQIJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:09:48 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39739 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752781AbYCQIJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:09:47 -0400
Date: Mon, 17 Mar 2008 03:09:42 -0500
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [4/18] Add basic support for more than one hstate in
 hugetlbfs
Message-Id: <20080317030942.8465b09e.pj@sgi.com>
In-Reply-To: <20080317015817.DE00E1B41E0@basil.firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
	<20080317015817.DE00E1B41E0@basil.firstfloor.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

Seems to me that both patches 2/18 and 4/18 are called:

  Add basic support for more than one hstate in hugetlbfs

You probably want to change this detail.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
