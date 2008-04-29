Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYD2MSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYD2MSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYD2MSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:18:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59234 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbYD2MS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:18:29 -0400
Date: Tue, 29 Apr 2008 21:18:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       trivial@kernel.org
In-Reply-To: <20080428154023.GU2813@cs181133002.pp.htv.fi>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi>
Message-Id: <20080429210315.354E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch converts some non-UTF-8 encoded text in comments to UTF-8.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Good Job!

   Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


AFAIK some file already are written by utf-8.
frankly, I say from the standpoint as the non-Europian,

all files are written by ascii:      no problem
all files are written by iso8859-1:  need editor customize
all files are written by utf-8:      no problem
some files are written by iso8859-1, 
but another files are written by utf-8: Ouch! Noooooo!!



