Return-Path: <linux-kernel-owner+w=401wt.eu-S2992924AbXDDPaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992924AbXDDPaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992933AbXDDPaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:30:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:57663 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992924AbXDDPaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:30:11 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: [2.6 patch] i386/x86_64: make __reserve_evntsel_nmi() static
References: <20070404152542.GL27660@stusta.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 04 Apr 2007 18:28:44 +0200
In-Reply-To: <20070404152542.GL27660@stusta.de>
Message-ID: <p73slbgxfwj.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> __reserve_evntsel_nmi() can become static.

It's going to die in .22 anyways, just a temporary .21 kludge.

-Andi
