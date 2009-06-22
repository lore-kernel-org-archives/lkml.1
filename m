Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZFVLcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZFVLcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZFVLcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:32:12 -0400
Received: from [212.98.175.89] ([212.98.175.89]:56565 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754028AbZFVLcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:32:11 -0400
Date: Mon, 22 Jun 2009 14:33:08 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090622113308.GA32155@localdomain.by>
References: <20090619181529.GA3593@localdomain.by>
 <20090620174320.GA6791@debian>
 <20090620185452.GD3138@localdomain.by>
 <20090622105721.262179f9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622105721.262179f9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/22/09 10:57), Alan Cox wrote:
> 
> Fix on its way upstream.
> 

Alan, can you send me patch so I can test it?

Thanks,
	Sergey
