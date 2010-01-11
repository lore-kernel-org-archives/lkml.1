Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489Ab0AKNZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0AKNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258Ab0AKNZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:25:55 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35316 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0AKNZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:25:55 -0500
Date: Mon, 11 Jan 2010 14:25:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kirill Afonshin <kirill_nnov@mail.ru>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] removed unused as_io_context
Message-ID: <20100111132554.GF4489@kernel.dk>
References: <E1NTKDf-0008NY-00.kirill_nnov-mail-ru@foot.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NTKDf-0008NY-00.kirill_nnov-mail-ru@foot.mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08 2010, Kirill Afonshin wrote:
> Jens, as_io_context isn't used anymore.

Thanks, yes that's definitely an oversight. Applied.

-- 
Jens Axboe

