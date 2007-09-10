Return-Path: <linux-kernel-owner+w=401wt.eu-S965603AbXIJQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965603AbXIJQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965261AbXIJQP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:15:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50596 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965241AbXIJQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:15:58 -0400
Date: Mon, 10 Sep 2007 18:15:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: pradeep singh rautela <rautelap@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Q]Adding src files to 2.6.18 kernel and build failure query
In-Reply-To: <6bc632150709100905y7c5c2camaa0044cf6fa09ea2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709101812160.5368@fbirervta.pbzchgretzou.qr>
References: <6bc632150709100905y7c5c2camaa0044cf6fa09ea2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 10 2007 21:35, pradeep singh rautela wrote:
>
>So , here is the question in short...
>
>What do i need to change and where to make sure this thing vanishes
>away and kernel compiles as usual like it always did earlier?

Perhaps post a patch that demonstrates the problem in short.

>Any pointers?

void *.

>pradeep singh rautela
>
>"question = ( to ) ? be : ! be;"
>                -- Wm. Shakespeare

More like
	$? = (${"2b"} || !${"2b"});

since : does not mean "or", but "else".


	Jan
-- 
