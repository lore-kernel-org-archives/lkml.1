Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbZJEC5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbZJEC5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 22:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbZJEC5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 22:57:39 -0400
Received: from dd2934.kasserver.com ([85.13.129.136]:52469 "EHLO
	dd2934.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbZJEC5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 22:57:39 -0400
Message-ID: <4AC9607D.6050900@datenparkplatz.de>
Date: Mon, 05 Oct 2009 04:57:01 +0200
From: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: complete IO hang since a few kernel revision
References: <20091005011626.GH4335@gamma.logic.tuwien.ac.at>
In-Reply-To: <20091005011626.GH4335@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,


I reported similar observations a short time ago on this mailing list.

There has been quite a bit of development been done in this area since
2.6.31. (See the postings under "Re: IO scheduler based IO controller
V10" of 2009-09-25 et seqq.)


A number of patches went into 2.6.32-rc3 which was released today.

Can you test if your problems are solved with this latest version?


(BTW, Thanks to Vivek Goyal, Jens Axboe, Mike Galbraith, Ingo Molnar,
Corrado Zoccolo and anyone who I forgot!)

