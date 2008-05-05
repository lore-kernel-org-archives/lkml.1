Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbYEEUQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbYEEUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbYEEUQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:16:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:8954 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbYEEUQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TDR2NBXVjw2cNMv0NGJM2u7iMkaCzql+lUgMvBwoZy+GSSNSmDrBkEVRxtrduD0Kf3ZcZQadLusQovsjf20xUrp5DBXgmBbTD0mQgx1jVFpCnG9tvZqqaZrTOtadiiQVF9KIO/RrpVAKL79GZu8Xtqa6m1pQAxpR4xdu6g4Mspk=
Message-ID: <2f11576a0805051316j42ae0a83yac3468a29108ed77@mail.gmail.com>
Date: Tue, 6 May 2008 05:16:40 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] mm/swapfile.c: make code static
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080505182705.GH17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080505182705.GH17139@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: daeca075eaf7e1c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch makes the following needlessly global code static:
>  - swap_lock
>  - nr_swapfiles
>  - struct swap_list
>
>  Signed-off-by: Adrian Bunk <bunk@kernel.org>

abosolutely.

             Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
