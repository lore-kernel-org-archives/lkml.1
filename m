Return-Path: <linux-kernel-owner+w=401wt.eu-S1766967AbXEBUVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766967AbXEBUVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766985AbXEBUVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:21:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44670 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766967AbXEBUVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:21:21 -0400
Message-ID: <4638F2DA.9080100@cs.helsinki.fi>
Date: Wed, 02 May 2007 23:21:46 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: remove duplicate VM_BUG_ON
References: <Pine.LNX.4.64.0705022307310.16215@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0705021311440.1978@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705021311440.1978@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Patch is already in mm. Could you download all the patches after that 
> before testing? There was quite a number.

I am on 2.6.21-rc7-mm2. Me goes to wonder where Andrew's snapshots are...
