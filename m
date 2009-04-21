Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZDUPdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZDUPdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZDUPdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:33:33 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:49363 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZDUPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:33:32 -0400
Date: Tue, 21 Apr 2009 11:25:34 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/25] Calculate the cold parameter for allocation only
 once
In-Reply-To: <20090421151355.GA29083@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0904211122540.21796@qirst.com>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <1237543392-11797-12-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201109250.3740@qirst.com> <20090421151355.GA29083@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Mel Gorman wrote:

> On Fri, Mar 20, 2009 at 11:09:40AM -0400, Christoph Lameter wrote:
> >
> > Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> I apologise, I've it added now. While the patch is currently dropped from the
> set, I'll bring it back later for further discussion when it can be
> established if it really helps or not.

Sooo much self-doubt..... Could you post the not included patches at the
end of your patchsets so that others can help improve those?



