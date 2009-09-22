Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZIVXUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZIVXUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZIVXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:20:31 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52798 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064AbZIVXUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:20:31 -0400
Date: Tue, 22 Sep 2009 19:07:28 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: =?GB2312?B?t8nR1Q==?= <win847@gmail.com>
cc: Mel Gorman <mel@csn.ul.ie>, Sachin Sant <sachinp@in.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
In-Reply-To: <363172900909220629j2f5174cbo9fe027354948d37@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0909221904550.24141@V090114053VZO-1>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie>  <20090921174656.GS12726@csn.ul.ie>  <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1>  <20090921180739.GT12726@csn.ul.ie> <4AB85A8F.6010106@in.ibm.com>  <20090922125546.GA25965@csn.ul.ie>
 <4AB8CB81.4080309@in.ibm.com>  <20090922132018.GB25965@csn.ul.ie> <363172900909220629j2f5174cbo9fe027354948d37@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, ?? wrote:

> 800KB. How can I config kernel config to reduce kernel size, I want to get
> smaller size  like 500KB.


500kb? That may be a tough call.

> *CONFIG_NETFILTER=y*

Can you drop this one?

Is CONFIG_EMBEDDED set? Maybe I skipped it.

