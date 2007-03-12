Return-Path: <linux-kernel-owner+w=401wt.eu-S965751AbXCLMkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751AbXCLMkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 08:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965809AbXCLMkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 08:40:10 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:47155 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965751AbXCLMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 08:40:08 -0400
Date: Mon, 12 Mar 2007 13:40:07 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20*: PATA DMA timeout, hangs (2)
Message-ID: <20070312124007.GB12265@janus>
References: <20070312085447.GA10955@janus> <20070312112414.GA12265@janus> <200703121321.18299.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703121321.18299.bzolnier@gmail.com>
User-Agent: Mutt/1.4.1i
X-BotBait: val@frankvm.com, kuil@frankvm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 01:21:18PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> Could you check if this is the same problem as this one:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8169

Looks like it except that I don't see "lost interrupt" messages here. So,
it might be something different (I don't know).

-- 
Frank
