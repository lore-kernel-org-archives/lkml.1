Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYLDIxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYLDIxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYLDIxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:53:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:53308 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYLDIxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:53:08 -0500
Subject: Re: [ltt-dev] trace a futex
From: Peter Zijlstra <peterz@infradead.org>
To: prasad@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>, jan.kiszka@web.de,
       Gian Lorenzo Meocci <glmeocci@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org, mbligh@google.com
In-Reply-To: <20081203180131.GA2904@in.ibm.com>
References: <8d94e9280812021142j2eb5ca72td730410e97ccd9a1@mail.gmail.com>
	 <20081202195015.GA25792@Krystal>
	 <8d94e9280812021215m6a63d6c2l4e64acd26274953d@mail.gmail.com>
	 <20081202215519.GA734@Krystal> <4935B25F.7010701@web.de>
	 <20081203052640.GA13701@Krystal>  <20081203180131.GA2904@in.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2008 09:53:04 +0100
Message-Id: <1228380784.5092.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FWIW, the ftrace infrastructure has on many an occasion (even before it
was called ftrace and specific to -rt) helped in debugging and fixing
futex races.
