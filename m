Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbYGOCYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbYGOCYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGOCYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:24:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34324
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761516AbYGOCYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:24:24 -0400
Date: Mon, 14 Jul 2008 19:24:25 -0700 (PDT)
Message-Id: <20080714.192425.241878700.davem@davemloft.net>
To: rene.herman@keyaccess.nl
Cc: david@lang.hm, torvalds@linux-foundation.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <487C0A12.9060906@keyaccess.nl>
References: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
	<20080714.185207.203328391.davem@davemloft.net>
	<487C0A12.9060906@keyaccess.nl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rene Herman <rene.herman@keyaccess.nl>
Date: Tue, 15 Jul 2008 04:23:14 +0200

> On 15-07-08 03:52, David Miller wrote:
> 
> > From: david@lang.hm Date: Mon, 14 Jul 2008 17:51:37 -0700 (PDT)
> > 
> >> I agree with this, but the proponents of the seperate firmware are
> >> listing the fact that the firmware doesn't tie up ram as one of the
> >> big reasons for making the change.
> > 
> > Exactly.
> > 
> > Otherwise these firmware changes are utterly pointless.
> 
> The point of them is legal.

Thanks for proving something I tried to establish for weeks
but which Alan Cox, David W., and others vehemently denied.

They states that it was being done on a technical basis rather
than being predominantly a legal one.
