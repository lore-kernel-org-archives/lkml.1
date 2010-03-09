Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0CIQF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:05:28 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:53820 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0CIQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:05:26 -0500
Subject: Re: opendir() on a file???
From: Jon Masters <jonathan@jonmasters.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a36005b51003090659m641b1297g32f3327b83917452@mail.gmail.com>
References: <1268126817.10479.643.camel@localhost>
	 <a36005b51003090659m641b1297g32f3327b83917452@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 09 Mar 2010 11:05:20 -0500
Message-ID: <1268150720.10479.674.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 06:59 -0800, Ulrich Drepper wrote:
> On Tue, Mar 9, 2010 at 01:26, Jon Masters <jonathan@jonmasters.org> wrote:
> > Now I might be missing something, and I know I'm behind on LKML[0], but
> > the following isn't supposed to work in my book:
> 
> Al introduced and fixed the problem, from what I've seen.

Thanks. It's fixed in today's rawhide.

Jon.


