Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYCYQy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYCYQy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbYCYQyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:54:41 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44971 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757050AbYCYQyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:54:41 -0400
Date: Tue, 25 Mar 2008 11:54:38 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: mingo@elte.hu, ak@suse.de, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Increase max physical memory size of x86_64
Message-ID: <20080325165438.GA5298@sgi.com>
References: <20080321133157.GA10911@sgi.com> <20080325164154.GA5909@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325164154.GA5909@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 05:41:54PM +0100, Andreas Herrmann wrote:
> On Fri, Mar 21, 2008 at 08:31:57AM -0500, Jack Steiner wrote:
> > Increase the maximum physical address size of x86_64 system
> > to 44-bits. This is in preparation for future chips that
> > support larger physical memory sizes.
> 
> Shouldn't this be increased to 48?
> AMD family 10h CPUs actually support 48 bits for the
> physical address.

You are probably correct but I don't work with AMD processors
and don't understand their requirements. If someone
wants to submit a patch to support larger phys memory sizes,
I certainly have no objections....


--- jack
