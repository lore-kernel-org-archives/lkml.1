Return-Path: <linux-kernel-owner+w=401wt.eu-S1764634AbYDNR5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764634AbYDNR5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYDNR5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:57:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40831 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756832AbYDNR5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:57:31 -0400
Date: Mon, 14 Apr 2008 10:57:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2: IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
In-Reply-To: <Pine.LNX.4.64.0804141050550.6296@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0804141056350.6296@schroedinger.engr.sgi.com>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> 
 <20080413204422.GA5136@martell.zuzino.mipt.ru>
 <84144f020804140901p1c076fd2q73e3effe7cd96da3@mail.gmail.com>
 <Pine.LNX.4.64.0804141050550.6296@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

500000000 is 21474836480. So 21GB boundary? Some sort of device?


