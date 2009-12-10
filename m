Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbZLJQWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbZLJQWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbZLJQWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:22:10 -0500
Received: from waste.org ([173.11.57.241]:55077 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492AbZLJQWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:22:10 -0500
Subject: Re: upstream regression: slob hang
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20091210084949.GA18015@elte.hu>
References: <20091210084949.GA18015@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Dec 2009 10:22:13 -0600
Message-ID: <1260462133.24459.1006.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 09:49 +0100, Ingo Molnar wrote:
> FYI, the attached config hangs in the SLOB code, on 32-bit x86 laptop 
> (dual core). No log available from that box.

Is this one of your randconfigs? I take it switching from SLOB to SLUB
fixes it?

-- 
http://selenic.com : development and support for Mercurial and Linux


