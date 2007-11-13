Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbXKMKvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbXKMKvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXKMKvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:51:32 -0500
Received: from eazy.amigager.de ([213.239.192.238]:40213 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXKMKvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:51:32 -0500
Date: Tue, 13 Nov 2007 11:51:19 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: XFS related Oops
Message-ID: <20071113105119.GA11527@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20071112064706.GA23595@dose.home.local> <20071112222720.GG995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071112222720.GG995458@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 09:27:20 +1100, David Chinner wrote:

[...]

> No. I'd say something got screwed up during suspend/resume. Is it
> reproducable?

No. I often use suspend to RAM, and usually it works without such
failures. I restart squid during the resume prosecure, and the above
Oops lead to a squid in D state.

Regards,
Tino
