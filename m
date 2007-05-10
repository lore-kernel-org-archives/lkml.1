Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbXEJSHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbXEJSHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbXEJSHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:07:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49208 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760910AbXEJSHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:07:37 -0400
Date: Thu, 10 May 2007 11:07:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@osdl.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] memory hotremove patch take 2 [04/10] (isolate all free
 pages)
In-Reply-To: <20070509120434.B90E.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0705101107250.10002@schroedinger.engr.sgi.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
 <20070509120434.B90E.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think would also be taken care of by Mel's existing framework.


