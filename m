Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXH0UAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXH0UAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbXH0UAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:00:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35681 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757151AbXH0UAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:00:34 -0400
Date: Mon, 27 Aug 2007 13:00:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dave Airlie <airlied@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       dri-devel <dri-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>, jes@sgi.com
Subject: Re: uncached page allocator
In-Reply-To: <1187708165.6114.256.camel@twins>
Message-ID: <Pine.LNX.4.64.0708271258420.5457@schroedinger.engr.sgi.com>
References: <21d7e9970708191745h3b579f3bp72f138e089c624da@mail.gmail.com> 
 <20070820094125.209e0811@the-village.bc.nu> 
 <21d7e9970708202305h5128aa5cy847dafe033b00742@mail.gmail.com>
 <1187708165.6114.256.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is an uncached allocator in IA64 arch code 
(linux/arch/ia64/kernel/uncached.c). Maybe having a look at 
that will help? Jes wrote it.
