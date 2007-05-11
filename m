Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbXEKRzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbXEKRzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbXEKRyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:54:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59066 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925AbXEKRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:54:54 -0400
Message-ID: <4644AE05.5080308@cs.helsinki.fi>
Date: Fri, 11 May 2007 20:55:17 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: clameter@sgi.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [patch 2/2] Slab allocators: Drop support for destructors
References: <20070511165749.026947116@sgi.com> <20070511165946.145806097@sgi.com>
In-Reply-To: <20070511165946.145806097@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clameter@sgi.com wrote:
> There is no user of destructors left. There is no reason why we should
> keep checking for destructors calls in the slab allocators.

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
