Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYAORyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYAORyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYAORxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:53:48 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30066 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbYAORxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:53:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xOYEQ1LmyG/5itLlZY5NQhT0mNv4AT3Xxv5803JCfaEXHLkksDosrSxd6iYQ/CDHG
	WBuXx73i97SUyDIcNUEug==
Message-ID: <532480950801150953g5a25f041ge1ad4eeb1b9bc04b@mail.gmail.com>
Date: Tue, 15 Jan 2008 09:53:42 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, wfg@mail.ustc.edu.cn
In-Reply-To: <1200386774.15103.20.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115080921.70E3810653@localhost>
	 <1200386774.15103.20.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 12:46 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Just a quick question, how does this interact/depend-uppon etc.. with
> Fengguangs patches I still have in my mailbox? (Those from Dec 28th)

They don't. They apply to a 2.6.24rc7 tree. This is a candidte for 2.6.25.

This work was done before Fengguang's patches. I am trying to test
Fengguang's for comparison but am having problems with getting mm1 to
boot on my systems.

mrubin
