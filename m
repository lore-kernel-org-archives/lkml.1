Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZLNAdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZLNAdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZLNAdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:33:23 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:55904 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbZLNAdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 19:33:22 -0500
Date: Mon, 14 Dec 2009 11:33:20 +1100
From: Simon Horman <horms@verge.net.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: liu weni <qingshenlwy@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: Re: [PATCH v2]kernel: remove mess codes
Message-ID: <20091214003320.GA29218@verge.net.au>
References: <b3657a100912122255j138bb9e6s785bdc8152a27691@mail.gmail.com>
 <4B249210.7060103@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B249210.7060103@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 11:04:48PM -0800, Jeremy Fitzhardinge wrote:
> On 12/12/09 22:55, liu weni wrote:
> >I found some mess characters(0x0c) in the kernel source code.
> >Then I suggest remove it.
> 
> Those are form-feed characters.   Some editors use them to separate
> logically distinct blocks of code into separate "pages".

I can see their value in documentation, but I struggle to imagine
their usefulness in code.

