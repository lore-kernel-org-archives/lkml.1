Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYIEQSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYIEQSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYIEQSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:18:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50528 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYIEQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:18:41 -0400
Subject: Re: [RFC][PATCH] dynamically enable readprofile at runtime
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080904190308.6d377ac6.randy.dunlap@oracle.com>
References: <20080829202713.348431DC@kernel>
	 <20080904190308.6d377ac6.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 09:18:36 -0700
Message-Id: <1220631516.23386.126.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 19:03 -0700, Randy Dunlap wrote:
> > +#ifdef CONFIG_PROFILING
> > +/* uevent helper program, used during early boo */
> 
> s/boo/boot/ ??

Well, my crappy copied comment has a typo in it.  I really meant "boo".
I was trying to scare patch reviewers.

I'll have a new one out in a bit, akpm found another issue in it.

-- Dave

