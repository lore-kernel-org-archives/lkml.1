Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZAQMoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZAQMoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 07:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbZAQMoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 07:44:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756831AbZAQMoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 07:44:06 -0500
Date: Sat, 17 Jan 2009 04:43:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
Message-Id: <20090117044316.bda7d0bd.akpm@linux-foundation.org>
In-Reply-To: <1232194752.6273.5.camel@marge.simson.net>
References: <20090111144305.GA7154@elte.hu>
	<20090114121521.197dfc5e.akpm@linux-foundation.org>
	<1231964647.14825.59.camel@laptop>
	<20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	<1232173776.7073.21.camel@marge.simson.net>
	<1232186054.6813.48.camel@marge.simson.net>
	<1232186877.14073.59.camel@laptop>
	<1232188484.6813.85.camel@marge.simson.net>
	<1232193617.14073.67.camel@laptop>
	<1232194752.6273.5.camel@marge.simson.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


http://bugzilla.kernel.org/show_bug.cgi?id=12465 just popped up - another
scheduler regression.  It has been bisected.
