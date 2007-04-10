Return-Path: <linux-kernel-owner+w=401wt.eu-S1030178AbXDJA4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030178AbXDJA4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030197AbXDJA4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:56:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59212 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030178AbXDJA4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:56:48 -0400
Date: Mon, 9 Apr 2007 17:56:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nishanth Aravamudan <nacc@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       drfickle@us.ibm.com
Subject: Re: 2.6.21-rc6-mm1
In-Reply-To: <20070410005054.GA4027@us.ibm.com>
Message-ID: <Pine.LNX.4.64.0704091755380.28009@schroedinger.engr.sgi.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
 <20070410005054.GA4027@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007, Nishanth Aravamudan wrote:

> I am not sure if there are other users of page_private() that were
> missed that are also compound pages, but probably the attached will fix
> this case?

Correct. 

Acked-by: Christoph Lameter <clameter@sgi.com>

Who is off to look for more of these.
