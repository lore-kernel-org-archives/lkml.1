Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZBVRFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZBVRFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZBVRFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:05:13 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:33851 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbZBVRFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:05:11 -0500
Date: Sun, 22 Feb 2009 17:05:04 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck updates for -tip
Message-ID: <20090222170504.GB27360@silver.sucs.org>
References: <20090222135739.GA28619@damson.getinternet.no> <20090222164419.GA28442@elte.hu> <20090222170044.GC6003@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222170044.GC6003@nowhere>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 06:00:45PM +0100, Frederic Weisbecker wrote:
> 
> BTW, I just tested kmemcheck (without these fixes pulled) and encountered some
> troubles with the function graph tracer which hangs during the self tests.
> As well as a message from hrtimer which tells its interrupt is too slow.

I had function graph self test issues with kmemcheck in -tip yesterday
too (without kmemcheck the the function call graph finished quickly). I
left it going a full 10 minutes before concluding my machine was too
slow... Perhaps there is more to it? : )

-- 
Sitsofe | http://sucs.org/~sits/
