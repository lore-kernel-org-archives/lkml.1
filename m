Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXAWDnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXAWDnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 22:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820AbXAWDnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 22:43:42 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:55874 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932794AbXAWDnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 22:43:42 -0500
Date: Mon, 22 Jan 2007 19:43:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Balbir Singh <balbir@in.ibm.com>
cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: Why active list and inactive list?
In-Reply-To: <45B582CF.1050408@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0701221942490.30909@schroedinger.engr.sgi.com>
References: <45B55286.5060909@nobaq.net> <20070123003939.GY13798@opteron.random>
 <45B56575.10807@in.ibm.com> <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
 <45B569A4.3010006@redhat.com> <45B582CF.1050408@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007, Balbir Singh wrote:

> I have always wondered if it would be useful to have a kernel debug
> feature that can extract page references per task, it would be good
> to see the page references (last 'n') of a workload that is not
> doing too well on a particular system.

perfmon can do much of what you are looking for.

