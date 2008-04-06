Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYDFOYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYDFOYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 10:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYDFOYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 10:24:37 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55654 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbYDFOYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 10:24:36 -0400
Date: Sun, 6 Apr 2008 16:06:24 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Realtek 8111c weirdness problems, apic/msi, and normal bug
Message-ID: <20080406140624.GA24479@electric-eye.fr.zoreil.com>
References: <1207407804.14885.27.camel@localhost> <20080405232354.57ff2fac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080405232354.57ff2fac.akpm@linux-foundation.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> :
[...]
> > /proc/interrupts, dmesg, ethtool on .25 apic/nomsi?

Complete dmesg and lspci -vvxn for a start.

-- 
Ueimor
