Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbZA3ENA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbZA3ENA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 23:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbZA3EMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 23:12:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:57016 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153AbZA3EMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 23:12:41 -0500
Subject: Re: 2.6.28-rt on PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: avorontsov@ru.mvista.com
Cc: Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20090130030758.GA7004@oksana.dev.rtsoft.ru>
References: <20090129213429.GA29014@oksana.dev.rtsoft.ru>
	 <1233281510.18767.17.camel@pasglop>
	 <20090130030758.GA7004@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 15:09:55 +1100
Message-Id: <1233288595.18767.20.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Actually, it doesn't matter whether a controller is a root IC or
> cascaded. Just as primary handlers, chained handlers don't run in
> threads, thus spinlocks should be used, not sleeping locks.

Sounds good then.

Cheers,
Ben.


