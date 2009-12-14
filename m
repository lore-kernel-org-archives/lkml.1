Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZLNHlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZLNHlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZLNHlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:41:13 -0500
Received: from relay.atmel.no ([80.232.32.139]:51683 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbZLNHlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:41:13 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 02:41:12 EST
Date: Mon, 14 Dec 2009 08:33:50 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: "kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] atmel-ssc.c: use resource_suze()
Message-ID: <20091214083350.0d51ab0e@hcegtvedt.norway.atmel.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB1110@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901FB1110@mi8nycmail19.Mi8.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 19:19:29 -0500
"H Hartley Sweeten" <hartleys@visionengravers.com> wrote:

> Use resource_size() for ioremap.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

-- 
Best regards,
Hans-Christian Egtvedt
