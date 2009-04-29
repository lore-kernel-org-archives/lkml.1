Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbZD2HEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbZD2HEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZD2HE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:04:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbZD2HE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:04:27 -0400
Date: Wed, 29 Apr 2009 09:04:23 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sachin Sant <sachinp@in.ibm.com>, linuxppc-dev@ozlabs.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-ID: <20090429070423.GB3398@wotan.suse.de>
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F6E421.401@in.ibm.com> <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 02:22:06PM +0300, Pekka Enberg wrote:
> Nick,
> 
> Here's another one. I think we need to either fix these rather quickly
> or make SLUB the defaut for linux-next again so we don't interfere
> with other testing.

Yeah, I'm working on it. Let me either give you a fix or a patch to
change the default, by the end of the day ;)

Thanks,
Nick
