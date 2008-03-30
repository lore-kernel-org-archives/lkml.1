Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYC3Lfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYC3Lfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYC3Lfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:35:44 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43985 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbYC3Lfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:35:43 -0400
Date: Sun, 30 Mar 2008 15:35:34 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/35] W1: w1.c s/printk/dev_dbg/
Message-ID: <20080330113534.GJ15122@2ka.mipt.ru>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net> <20080328122650.GU3613@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328122650.GU3613@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

17-20 patches are non-critical cleanups, please combine them into single
patch. Thanks.

On Fri, Mar 28, 2008 at 07:26:50AM -0500, David Fries (david@fries.net) wrote:
> w1.c 1.18
> Code cleanup, more of a just because.
> s/printk/dev_dbg/

-- 
	Evgeniy Polyakov
