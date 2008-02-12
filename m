Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbYBLXVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbYBLXVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYBLXUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:20:47 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:43751 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYBLXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:20:45 -0500
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
From: Dave Hansen <haveblue@us.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, greg@kroah.com,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <1202857416.25604.71.camel@dyn9047017100.beaverton.ibm.com>
References: <20080211114818.74c9dcc7.akpm@linux-foundation.org>
	 <1202765553.25604.12.camel@dyn9047017100.beaverton.ibm.com>
	 <20080212154309.F9DA.Y-GOTO@jp.fujitsu.com>
	 <1202836953.25604.42.camel@dyn9047017100.beaverton.ibm.com>
	 <1202849972.11188.71.camel@nimitz.home.sr71.net>
	 <1202853415.25604.59.camel@dyn9047017100.beaverton.ibm.com>
	 <1202853434.11188.76.camel@nimitz.home.sr71.net>
	 <1202854031.25604.62.camel@dyn9047017100.beaverton.ibm.com>
	 <1202854520.11188.90.camel@nimitz.home.sr71.net>
	 <1202857416.25604.71.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 15:20:48 -0800
Message-Id: <1202858448.11188.108.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 15:03 -0800, Badari Pulavarty wrote:
> Here is the version with your suggestion. Do you like this better ?

I do like how it looks, better, thanks.


