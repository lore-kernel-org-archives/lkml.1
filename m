Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYFCJu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYFCJu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 05:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYFCJuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 05:50:51 -0400
Received: from styx.suse.cz ([82.119.242.94]:57992 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752062AbYFCJuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 05:50:50 -0400
Date: Tue, 3 Jun 2008 11:50:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linuxfoundation.org>
cc: alexander@comm.utoronto.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbhid: Fix fn key on Macbook Pro 4,1 and Macbook Air
In-Reply-To: <20080529164554.0d3b6606.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806031150230.6718@jikos.suse.cz>
References: <36765.142.151.170.214.1212101197.squirrel@webmail.comm.utoronto.ca>
 <20080529164554.0d3b6606.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Andrew Morton wrote:

> > Added device ids to hid-quriks for detection of keyboards on 4th 
> > generation Macbook Pro and Macbook Air
> Jiri, I'll assume this this is destined for your tree.  Perhaps
> suitable for 2.6.26?   I can merge it at your request, as always.

I will merge it through my tree, thanks.

-- 
Jiri Kosina
SUSE Labs
