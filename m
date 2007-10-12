Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbXJLOun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbXJLOun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXJLOuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:50:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59877 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbXJLOuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:50:35 -0400
Date: Fri, 12 Oct 2007 07:48:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: NMI watchdog
Message-ID: <20071012074836.79e6a064@laptopd505.fenrus.org>
In-Reply-To: <470F3BE0.4050807@free.fr>
References: <470F3BE0.4050807@free.fr>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 11:18:24 +0200
John Sigler <linux.kernel@free.fr> wrote:

> Hello,
> 
> I'm experiencing a full system lockup. I'm using an out-of-tree
> driver which I suspect is responsible. I'm trying to enable the NMI
> watchdog.


one thing worth a shot is enabling lockdep.. that often finds deadlocks
for you ;)
