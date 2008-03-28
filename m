Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYC1C0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYC1C0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbYC1C0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:26:39 -0400
Received: from gw.goop.org ([64.81.55.164]:35192 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbYC1C0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:26:38 -0400
Message-ID: <47EC574C.10006@goop.org>
Date: Thu, 27 Mar 2008 19:26:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3 of 4] sparsemem: reduce i386 PAE section size
References: <b7d0773c79887ca98d6c.1206664119@localhost> <Pine.LNX.4.64.0803271734450.10635@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0803271734450.10635@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>
> There are patches in mm which changes that situation. You should have 5 or 
> 6 more flags to play with.
>   

Oh, good.  We can play with it some more when everything gets merged 
together.

    J

