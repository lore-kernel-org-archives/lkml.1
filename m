Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXJWSXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXJWSXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXJWSW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:22:56 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:52013 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXJWSWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:22:55 -0400
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org,
       Marek Dabek <marek.dabek@intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
X-Message-Flag: Warning: May contain useful information
References: <471CDC5E.4010300@linux.intel.com>
	<20071022114001.40470c15.akpm@linux-foundation.org>
	<20071023150429.GK4003@csclub.uwaterloo.ca>
	<20071023092333.39982483@laptopd505.fenrus.org>
	<20071023180547.GL4003@csclub.uwaterloo.ca>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 23 Oct 2007 11:22:50 -0700
In-Reply-To: <20071023180547.GL4003@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Tue, 23 Oct 2007 14:05:48 -0400")
Message-ID: <adar6jl6685.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Oct 2007 18:22:52.0827 (UTC) FILETIME=[B9A056B0:01C815A1]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > What does gcc have to say about if (foo = 0){ rather than if (foo == 0){

It's not a hard experiment to do.

The answer is:

    warning: suggest parentheses around assignment used as truth value

 - R.
