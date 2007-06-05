Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbXFETHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbXFETHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbXFETHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:07:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36388 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbXFETHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:07:10 -0400
Message-ID: <4665B469.3050208@cs.helsinki.fi>
Date: Tue, 05 Jun 2007 22:07:21 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org> <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com> <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com> <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com> <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com> <20070604155355.bf29a3a8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com> <466523E0.3050605@gmail.com> <alpine.DEB.0.99.0706050804170.27388@sigma.j-a-k-j.com> <46655CEC.7070900@gmail.com> <alpine.DEB.0.99.0706050951210.30666@sigma.j-a-k-j.com> <466573E0.8050809@gmail.com>
In-Reply-To: <466573E0.8050809@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> If I'd have a few small children around I'd show them the word 
> ZERO_SIZE_PTR and make pictures of them bursting out in tears.

I strongly recommend against it, linux/mm/*.c is for adults only.

			Pekka
