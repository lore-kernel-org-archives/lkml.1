Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbYCURgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbYCURgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYCURgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:36:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48572 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752090AbYCURgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:36:35 -0400
Date: Fri, 21 Mar 2008 10:35:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2/2] vmallocinfo: Add caller information
In-Reply-To: <20080321110008.GW20420@elte.hu>
Message-ID: <Pine.LNX.4.64.0803211034140.18671@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com>
 <20080319214227.GA4454@elte.hu> <Pine.LNX.4.64.0803191659410.4645@schroedinger.engr.sgi.com>
 <20080321110008.GW20420@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Ingo Molnar wrote:

> then make STACKTRACE available generally via the patch below.

How do I figure out which nesting level to display if we'd do this?
