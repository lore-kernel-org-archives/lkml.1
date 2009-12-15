Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZLOGpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZLOGpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZLOGpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:45:21 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48611 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZLOGpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:45:20 -0500
Subject: Re: upstream regression: slob hang
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1260815761.24459.1434.camel@calx>
References: <20091210084949.GA18015@elte.hu>
	 <4B268366.6090207@cs.helsinki.fi>  <1260815761.24459.1434.camel@calx>
Date: Tue, 15 Dec 2009 08:45:18 +0200
Message-Id: <1260859518.4770.4.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> > > FYI, the attached config hangs in the SLOB code, on 32-bit x86 laptop 
> > > (dual core). No log available from that box.

On Mon, 2009-12-14 at 20:26 +0200, Pekka Enberg wrote:
> > Boots fine on my 32-bit x86 laptop.

On Mon, 2009-12-14 at 12:36 -0600, Matt Mackall wrote:
> Thanks, Pekka. I've been too busy to experiment with this. Ingo,
> anything interesting about your laptop? How much memory do you have?

Side note: SLOB hasn't really changed for a while so I suspect Ingo is
hitting some once in a blue moon type of old bug.

