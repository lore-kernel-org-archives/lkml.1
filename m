Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZJLLJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZJLLJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZJLLJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:09:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40725 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZJLLJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:09:02 -0400
Date: Mon, 12 Oct 2009 12:08:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nitin Gupta <ngupta@vflare.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
Message-ID: <20091012110814.GA32113@n2100.arm.linux.org.uk>
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org> <20091012090710.GA29310@n2100.arm.linux.org.uk> <4AD304B2.8000205@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD304B2.8000205@vflare.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 03:58:02PM +0530, Nitin Gupta wrote:
> On 10/12/2009 02:37 PM, Russell King - ARM Linux wrote:
> > On Mon, Oct 12, 2009 at 02:20:23PM +0530, Nitin Gupta wrote:
> >> Same problem exists on mips too.
> > 
> > Nice catch.  This logic came from sparc64, so I think you'd want to talk
> > to davem about it as well.
> > 
> > In the mean time, submitting your fix to the patch system would be great,
> > thanks.
> > 
> 
> Thanks for looking into this. I think this can make it to mainline if
> you could Ack it and perhaps CC Andrew to get his attention?

Or it could take a less tortuous route by going through my tree.
