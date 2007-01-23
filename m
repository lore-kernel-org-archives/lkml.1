Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbXAWCEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbXAWCEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 21:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXAWCEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 21:04:07 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:47074 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932614AbXAWCEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 21:04:06 -0500
Date: Mon, 22 Jan 2007 18:03:30 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Rik van Riel <riel@redhat.com>
cc: Balbir Singh <balbir@in.ibm.com>, Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
In-Reply-To: <45B569A4.3010006@redhat.com>
Message-ID: <Pine.LNX.4.64.0701221801420.30595@schroedinger.engr.sgi.com>
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random>
 <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
 <45B569A4.3010006@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007, Rik van Riel wrote:

> It would be really nice if we came up with a page replacement
> algorithm that did not need many extra heuristics to make it
> work...

I guess the "clock" type algorithms are the most promising in that 
area. What happened to all those advanced page replacement endeavors? 
What is the most promising of those? You seem to have done a lot of work 
on those.

