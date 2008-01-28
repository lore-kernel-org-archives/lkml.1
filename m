Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbYA1DP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbYA1DP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 22:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYA1DPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 22:15:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:51918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbYA1DPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 22:15:45 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] [0/18] Implement some low hanging BKL removal fruit in fs/*
Date: Mon, 28 Jan 2008 04:15:38 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
References: <20080127317.043953000@suse.de> <200801281259.15198.nickpiggin@yahoo.com.au>
In-Reply-To: <200801281259.15198.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801280415.38460.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> BTW. here is a patch I did a while back for minix. I know it isn't
> a big deal, but the work is done so I guess I should send it along.

Looks safe, although I'm surprised it actually gets around with such
little locking in general.

-Andi



