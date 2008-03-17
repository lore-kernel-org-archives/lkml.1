Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYCQKCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYCQKCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 06:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYCQKCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 06:02:16 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43044 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751991AbYCQKCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 06:02:15 -0400
Date: Mon, 17 Mar 2008 05:02:13 -0500
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [18/18] Implement hugepagesz= option for x86-64
Message-Id: <20080317050213.e2599a98.pj@sgi.com>
In-Reply-To: <20080317095955.GB12405@basil.nowhere.org>
References: <20080317258.659191058@firstfloor.org>
	<20080317015832.2E3DF1B41E0@basil.firstfloor.org>
	<20080317042939.051e76ff.pj@sgi.com>
	<20080317095955.GB12405@basil.nowhere.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi wrote:
> Yes, but that was already there before. I didn't change it.
> 
> I agree it should be fixed, but i would prefer to not mix 
> PPC specific patches into my patchkit

Ok - good plan.

Do you know offhand what would be the correct HW list for hugepages and
hugepagesz?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
