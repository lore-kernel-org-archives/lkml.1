Return-Path: <linux-kernel-owner+w=401wt.eu-S1761137AbXGKBQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761137AbXGKBQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbXGKBPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:15:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754443AbXGKBPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:15:51 -0400
Date: Tue, 10 Jul 2007 18:14:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Matthew Hawkins" <darthmdh@gmail.com>
Cc: "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Message-Id: <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
In-Reply-To: <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<200707102015.44004.kernel@kolivas.org>
	<b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 11:02:56 +1000 "Matthew Hawkins" <darthmdh@gmail.com> wrote:

> We all know swap prefetch has been tested out the wazoo since Moses was a
> little boy, is compile-time and runtime selectable, and gives an important
> and quantifiable performance increase to desktop systems.

Always interested.  Please provide us more details on your usage and
testing of that code.  Amount of memory, workload, observed results,
etc?

>  Save a Redhat
> employee some time reinventing the wheel and just merge it.  This wheel
> already has dope 21" rims, homes ;-)

ooh, kernel bling.
