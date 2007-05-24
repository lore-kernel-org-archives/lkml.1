Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbXEXX1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbXEXX1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbXEXX1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:27:23 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbXEXX1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:27:22 -0400
Message-ID: <46561E9A.7020402@zytor.com>
Date: Thu, 24 May 2007 16:24:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jacques Gelinas <jacques@solucorp.qc.ca>,
       Matija Nalis <mnalis@jagor.srce.hr>, Matija Nalis <mnalis@voyager.hr>,
       trivial@kernel.org
Subject: Re: [PATCH] Remove a few UMSDOS leftovers
References: <200705250058.29266.jesper.juhl@gmail.com> <46561AA5.8090908@zytor.com> <200705250115.04491.jesper.juhl@gmail.com>
In-Reply-To: <200705250115.04491.jesper.juhl@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Ok, that makes sense. How about this version : 

Could you document which numbers were actually used by umsdos, instead
of reserving a full block of 256?  Since it's dead, it's not going to
eat any more numbers.

	-hpa
