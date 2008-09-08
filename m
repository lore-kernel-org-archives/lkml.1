Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYIHKx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYIHKx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 06:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYIHKxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 06:53:20 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51561 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYIHKxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 06:53:20 -0400
Date: Mon, 8 Sep 2008 11:52:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 0 of 3] Low memory corruption detection and workaround
In-Reply-To: <patchbomb.1220777491@localhost>
Message-ID: <Pine.LNX.4.64.0809081150310.14401@blonde.site>
References: <patchbomb.1220777491@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Sep 2008, Jeremy Fitzhardinge wrote:
> 
> [ Hugh - I took the liberty of splitting your patch up into a delta on
>   top of mine, moving the pure bugfixes into my base patch, and
>   putting your additional code into the new patch From you with your
>   sign-off from the original patch, and adding my own sob to reflect
>   the changes I made.  I hope you don't mind. ]

Super, that's fine, thanks for sorting it out.
(I'll forgive you the build error under my name!)

Hugh
