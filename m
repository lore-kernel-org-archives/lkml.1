Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbZLNSgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbZLNSgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZLNSgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:36:06 -0500
Received: from waste.org ([173.11.57.241]:48391 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZLNSgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:36:05 -0500
Subject: Re: upstream regression: slob hang
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <4B268366.6090207@cs.helsinki.fi>
References: <20091210084949.GA18015@elte.hu>
	 <4B268366.6090207@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 12:36:01 -0600
Message-ID: <1260815761.24459.1434.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 20:26 +0200, Pekka Enberg wrote:
> Hi Ingo,
> 
> Ingo Molnar wrote:
> > FYI, the attached config hangs in the SLOB code, on 32-bit x86 laptop 
> > (dual core). No log available from that box.
> 
> Boots fine on my 32-bit x86 laptop.

Thanks, Pekka. I've been too busy to experiment with this. Ingo,
anything interesting about your laptop? How much memory do you have?

-- 
http://selenic.com : development and support for Mercurial and Linux


