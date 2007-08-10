Return-Path: <linux-kernel-owner+w=401wt.eu-S941970AbXHJUn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941970AbXHJUn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941920AbXHJUnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:43:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333AbXHJUnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:43:40 -0400
Date: Fri, 10 Aug 2007 21:43:37 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Jan Blunck <jblunck@suse.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/11] dm-snap: Remove dead queued_bios code
Message-ID: <20070810204337.GH2064@agk.fab.redhat.com>
Mail-Followup-To: Jan Blunck <jblunck@suse.de>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
References: <20070810200204.455820246@suse.de>> <20070810200205.299669010@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810200205.299669010@suse.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:02:07PM +0200, Jan Blunck wrote:
> This patch removes the unused queued_bios handling code.
 
Well I'm going to leave this in for now (as one existing unfinished
patch series does build upon it).  We can include its removal as part of
your following patch series that no doubt replaces the functionality
with something better.

Alasdair
-- 
agk@redhat.com
