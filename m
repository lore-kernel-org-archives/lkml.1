Return-Path: <linux-kernel-owner+w=401wt.eu-S965475AbXECHgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbXECHgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965686AbXECHgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:36:40 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42133 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965475AbXECHgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:36:39 -0400
Date: Thu, 3 May 2007 09:32:25 +0200
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070503093225.10765f46@frecb000686.frec.bull.fr>
In-Reply-To: <Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 03/05/2007 09:39:33,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 03/05/2007 09:39:34,
	Serialize complete at 03/05/2007 09:39:34
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 16:28:27 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:


> +		$warnings += search(qr/__FUNCION__/,

                                       ^__FUNCTION__ maybe?

> +			"Should use C99 __func__ instead of GNU __FUNCTION__\n");


  Sébastien.
