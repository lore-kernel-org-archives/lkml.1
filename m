Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbXEAPFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbXEAPFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXEAPFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:05:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50913 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbXEAPFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:05:43 -0400
Message-ID: <46375738.1010007@zytor.com>
Date: Tue, 01 May 2007 08:05:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Subject: Re: console font limits
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>	 <Pine.LNX.4.64.0705011347300.27246@anakin> <1178021516.4372.62.camel@daplas>
In-Reply-To: <1178021516.4372.62.camel@daplas>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> 
> And this will entail a lot of work to change (Is it worth it to rework
> the code and remove the limitation?). The linux-console project
> (http://linuxconsole.sourceforge.net/) might have , but I don't know its
> current status.
> 

Well, I think the consensus is that anything beyond that should be done
in userspace; the main such console daemon was Kon2 last I checked.

	-hpa
