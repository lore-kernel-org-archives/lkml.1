Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbYD2NBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbYD2NBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761598AbYD2NAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:00:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54679 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761585AbYD2NAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:00:52 -0400
Date: Sun, 27 Apr 2008 22:35:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, gprocida@madge.com, mingo@elte.hu,
       matthew@wil.cx, chas@cmf.nrl.navy.mil, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: ambassador: vcc_sf semaphore to mutex
Message-ID: <20080427223538.28974d97@infradead.org>
In-Reply-To: <20080428181445.546732331@mvista.com>
References: <20080428181445.546732331@mvista.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 11:14:45 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 

Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
