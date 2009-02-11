Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZBKMS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZBKMS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbZBKMSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:18:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49312 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbZBKMSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:18:17 -0500
Date: Wed, 11 Feb 2009 13:18:08 +0100
From: Michal Schmidt <mschmidt@redhat.com>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver
Message-ID: <20090211131808.2f608074@brian.englab.brq.redhat.com>
In-Reply-To: <1234312633.15410.546.camel@keith-laptop>
References: <1234312633.15410.546.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 16:37:13 -0800
Keith Mannthey <kmannth@us.ibm.com> wrote:

> + * This program is free software: you can redistribute it and/or
> modify
> + * it under the terms of the GNU General Public License as published
> by
> + * the Free Software Foundation, either version 3 of the License, or
> + * (at your option) any later version.

GPLv3+ is not compatible with Linux's GPLv2, is it?

Michal
