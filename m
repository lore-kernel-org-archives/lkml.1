Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXECHUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXECHUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbXECHUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:20:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42838 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbXECHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:20:33 -0400
Message-ID: <46398D1F.1020306@zytor.com>
Date: Thu, 03 May 2007 00:19:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Albert Cahalan <acahalan@gmail.com>
CC: "Antonino A. Daplas" <adaplas@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Subject: Re: console font limits
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>	 <Pine.LNX.4.64.0705011347300.27246@anakin>	 <1178021516.4372.62.camel@daplas> <46375738.1010007@zytor.com> <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
In-Reply-To: <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan wrote:
> Font size is not a sane place to draw the line. Features are.

Font sizes are an eminently sane place to draw the line, because the
crossover is largely determined by the point at which nailing down too
much memory (kernel memory = unswappable memory) gets too expensive.

	-hpa
