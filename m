Return-Path: <linux-kernel-owner+w=401wt.eu-S1422821AbXBALhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422821AbXBALhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422817AbXBALhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:37:07 -0500
Received: from ns2.suse.de ([195.135.220.15]:56488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422821AbXBALgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:36:36 -0500
From: Andi Kleen <ak@suse.de>
To: jbohac@suse.cz
Subject: Re: [patch 2/9] Remove the support for the VXTIME_PMTMR timer mode
Date: Thu, 1 Feb 2007 12:13:31 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.508377000@jet.suse.cz>
In-Reply-To: <20070201103753.508377000@jet.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011213.32278.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
> VXTIME_PMTMR will be replaced by a more generic "Master Timer"

This means we have no fallback if something goes wrong with the Master timer? 

A little risky.

-Andi

