Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbYCMU2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbYCMU2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbYCMU2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:28:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbYCMU2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:28:03 -0400
Date: Thu, 13 Mar 2008 16:27:11 -0400
From: Rik van Riel <riel@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080313162711.3d483e6c@cuia.boston.redhat.com>
In-Reply-To: <200803131214.40321.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803122314.18244.phillips@phunq.net>
	<20080313132211.6af855b3@the-village.bc.nu>
	<200803131214.40321.phillips@phunq.net>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 11:14:39 -0800
Daniel Phillips <phillips@phunq.net> wrote:

> Scream is an exaggeration, and FUD only applies to somebody who
> consistently overlooks the primary proposition in this design: that the
> battery backed power supply, computer hardware and Linux are reliable
> enough to entrust your data to them. 

That's a reasonable enough assumption, to anyone who has never dealt
with software before, or whose data is just not important.

People who have dealt with computers for longer will know that anything
can fail at any time, and usually does unexpectedly and at bad moments.

Some defensive programming to deal with random failures could make your
project appealing to a lot more people than it would appeal to in its
current state.

-- 
All Rights Reversed
