Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYG2Aqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYG2Aqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYG2Aqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:46:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52579 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYG2Aqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:46:32 -0400
Date: Mon, 28 Jul 2008 18:46:15 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, eric@anholt.net,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/3] PCI: Handle 64-bit resources better on 32-bit machines
Message-ID: <20080729004615.GH16059@parisc-linux.org>
References: <1217266741-26519-1-git-send-email-matthew@wil.cx> <1217266741-26519-3-git-send-email-matthew@wil.cx> <200807281430.20687.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807281430.20687.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 02:30:20PM -0700, Jesse Barnes wrote:
> Both this and 1/3 look good, I've applied them to my for-linus tree.  I'll 
> push them out after a little testing.

Thanks!

> 3/3 also looks nice; is there any in-tree code that could be converted over to 
> using it?  If not, we can just push it as part of Eric's stuff.

I think it goes best with Eric's patches, but I wanted to get it review
here first.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
