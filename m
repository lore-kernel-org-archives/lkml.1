Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbYISOLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbYISOLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYISOL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:11:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54653 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYISOL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:11:28 -0400
Subject: Re: [patch 3/4] cpu alloc: The allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
In-Reply-To: <48D3A4F5.9010804@linux-foundation.org>
References: <20080918233648.581696416@quilx.com>
	 <20080918233701.599037712@quilx.com>
	 <84144f020809190058j425eb995y7f441da18079dc8d@mail.gmail.com>
	 <48D3A4F5.9010804@linux-foundation.org>
Date: Fri, 19 Sep 2008 17:12:09 +0300
Message-Id: <1221833529.15030.1.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-19 at 08:11 -0500, Christoph Lameter wrote:
> I thought we could handle early boot panics with early_printk?

Sure, but *if* we can limp along it's usually much nicer to debug
WARN_ONs that trigger during early boot. But anyway, I'm fine with
either way.

		Pekka

