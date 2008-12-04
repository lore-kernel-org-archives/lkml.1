Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYLDQNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYLDQNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 11:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYLDQNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 11:13:41 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:25118 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYLDQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 11:13:40 -0500
Message-ID: <493801AF.8050308@hp.com>
Date: Thu, 04 Dec 2008 11:13:35 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at block/blk-timeout.c:178!
References: <4937E888.3060208@hp.com> <20081204155005.GX18255@kernel.dk>
In-Reply-To: <20081204155005.GX18255@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:

> 
> Alan, can you try latest -git? feaf3848a813a106f163013af6fcf6c4bfec92d9
> or later.
> 

git pull()ed to: feaf3848a813a106f163013af6fcf6c4bfec92d9 and the same
problem occurs.

Alan
