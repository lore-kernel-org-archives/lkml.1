Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYKLRlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYKLRlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYKLRls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:41:48 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43957 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYKLRlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:41:47 -0500
Date: Wed, 12 Nov 2008 17:41:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nick Warne <nick@ukfsn.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make Dell keyboard repeat quirk apply to a wider range of hardware
Message-ID: <20081112174138.GA16647@srcf.ucam.org>
References: <20081111074702.75e71055@sauron.linicks.net> <20081112131427.1bbc2a7c@palantir.linicks.net> <20081112165650.GA15594@srcf.ucam.org> <20081112172429.674c4ff3@palantir.linicks.net> <20081112172712.GA16382@srcf.ucam.org> <20081112174010.209149e1@palantir.linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112174010.209149e1@palantir.linicks.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 05:40:10PM +0000, Nick Warne wrote:

> BTW, what was it that produced this issue in the first place?  All
> previous kernel versions worked OK?

It's the switch from kbd to evdev in Ubuntu, I suspect.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
