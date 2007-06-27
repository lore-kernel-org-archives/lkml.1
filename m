Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbXF0EsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbXF0EsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 00:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXF0Erz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 00:47:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41607 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbXF0Ery (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 00:47:54 -0400
Subject: Re: scheduling while atomic and DEBUG_SPINLOCK_SLEEP
From: Arjan van de Ven <arjan@infradead.org>
To: Jon Ringle <JRingle@vertical.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4DD3AF7ECBBC43409BA36508938D01851B0E7E@CVAEX1.VERTICAL.COM>
References: <4DD3AF7ECBBC43409BA36508938D01851B0E7E@CVAEX1.VERTICAL.COM>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 26 Jun 2007 21:46:49 -0700
Message-Id: <1182919609.3201.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 22:55 -0400, Jon Ringle wrote:
> Hello,
> Out of these two, the first one that is showing "in_atomic():1" seems
> more likely to me to be a potential cause of the "scheduling while
> atomic" dump.
> 
> Does this logic seem reasonable? Are there other debugging techniques I
> can use to narrow down the cause for the "scheduling while atomic"?


you could start by giving us pointers to the sources of the two
drivers... without that... how can we look and help?

