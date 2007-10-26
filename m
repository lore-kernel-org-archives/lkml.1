Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbXJZCA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbXJZCA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbXJZCAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:00:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38278 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753855AbXJZCAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:00:19 -0400
Date: Thu, 25 Oct 2007 19:00:17 -0700
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix bitmap_scnlistprintf for empty masks
Message-Id: <20071025190017.3adbefe3.pj@sgi.com>
In-Reply-To: <200710260342.43058.ak@suse.de>
References: <200710260342.43058.ak@suse.de>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi wrote:
> When a bitmap is empty bitmap_scnlistprintf would leave the buffer uninitialized.
> Set it to an empty string in this case.

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
