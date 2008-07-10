Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYGJNTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYGJNTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYGJNTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:19:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbYGJNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:19:41 -0400
Date: Thu, 10 Jul 2008 06:13:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Drivers for selfmade hardware
Message-Id: <20080710061334.fb7c8da0.akpm@linux-foundation.org>
In-Reply-To: <200807101457.47529.mb@bu3sch.de>
References: <200806292147.52112.mb@bu3sch.de>
	<20080709224557.45a85ff5.akpm@linux-foundation.org>
	<200807101457.47529.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 14:57:47 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> On Thursday 10 July 2008 07:45:57 Andrew Morton wrote:
> > #else
> > #define btgpio_suspend NULL
> > #define btgpio_resume NULL
> 
> Yeah I thought you had a patch in -mm which does this. Don't you?
> 

Nope.  A grep for btgpio_suspend comes up empty.
