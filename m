Return-Path: <linux-kernel-owner+w=401wt.eu-S939676AbXHIMln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939676AbXHIMln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939319AbXHIMlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52873 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939249AbXHIMlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:14 -0400
Date: Thu, 9 Aug 2007 14:41:12 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
In-Reply-To: <E1IJ7DO-0000pI-JN@be1.lrz>
Message-ID: <Pine.LNX.4.64.0708091439270.10387@fbirervta.pbzchgretzou.qr>
References: <8QdB3-87O-7@gated-at.bofh.it> <8QdUr-5j-11@gated-at.bofh.it>
 <E1IJ7DO-0000pI-JN@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 9 2007 14:34, Bodo Eggert wrote:
>
>I don't think <b> and <i> should be used, instead you should use styles
>(<span class="code"> etc).

<b> does the same as <span style="font-weight: bold;">, and the latter is much
more verbose for the same thing.

>Things like <em> and <strong> should be OK, if used consistently.
>
>> Perhaps maybe <p class="block"> with .block{text-align:justify;}
>> because that looks nice in general.
>
>If you like that, you can say "p {text-align:justify;}" in the default
>stylesheet. (And if people would override the alignment, class="block"
>would be the wrong name).

Oh that comes because MS Office calls it "Blocksatz" in German ;-)


	Jan
-- 
