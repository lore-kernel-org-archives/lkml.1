Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbXJCK5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbXJCK5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbXJCK5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:57:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbXJCK5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:57:07 -0400
Date: Wed, 3 Oct 2007 03:57:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: wibbling over the cpuset shed domain connnection
Message-Id: <20071003035703.d4efeae2.akpm@linux-foundation.org>
In-Reply-To: <20071003000058.aa3a414a.pj@sgi.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	<200710022236.59583.nickpiggin@yahoo.com.au>
	<20071002222158.1a083348.pj@sgi.com>
	<200710022312.17223.nickpiggin@yahoo.com.au>
	<20071003000058.aa3a414a.pj@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 00:00:58 -0700 Paul Jackson <pj@sgi.com> wrote:

> Nick wrote:
> > If code isn't ready to go, it doesn't need to rush, it can just be untangled
> > or fixed properly etc.

It's close enough for an rc1.

> True ... though we seem to be going in circles now.  I doubt
> taking longer will help much; we should strive to resolve this
> now, if we can.
> 

Please, work out what you want to do from a design perspective, then cook
up a patch against rc8-mm2.
