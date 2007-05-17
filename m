Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbXEQPHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbXEQPHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXEQPHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:07:24 -0400
Received: from smtp.nokia.com ([131.228.20.170]:29251 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXEQPHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:07:24 -0400
Subject: Re: [PATCH 06/44 take 2] [UBI] startup code
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
In-Reply-To: <20070517144420.GA3529@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165454.5845.30875.sendpatchset@localhost.localdomain>
	 <20070219105927.GB16930@infradead.org> <1171976456.4039.21.camel@sauron>
	 <20070225055828.GC9137@infradead.org> <20070517144420.GA3529@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 17 May 2007 18:06:10 +0300
Message-Id: <1179414370.3642.65.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 May 2007 15:06:10.0335 (UTC) FILETIME=[E71CBAF0:01C79894]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Thu, 2007-05-17 at 15:44 +0100, Christoph Hellwig wrote:
> So both I and Rusty told you not to do this and you did it anyway.
> 
> I'm quite pissed about this ignorance.  Andrew, what do we do about such
> a case?  Should we just revert ubi until they fixed their mess up?

Just for reference: http://lkml.org/lkml/2007/2/19/67

Sorry, I thought Rusty meant that we can use it if we invent our own
type, see the first part of his answer. You did not answer Frank's mail
about _why_ we use it. So I thought you agreed with us, I did not ignore
you, no need to be so assertive.

It is not a problem to fix this, but neither Rusty nor you explained
what is wrong with that call. But we _did_ explain why we use it. You
ignored the explanation and the questions.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

