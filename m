Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZIQXWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZIQXWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZIQXWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:22:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39376 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750741AbZIQXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:22:20 -0400
Date: Fri, 18 Sep 2009 00:23:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jung-Ik (John) Lee" <jilee@google.com>
Cc: sshtylyov@ru.mvista.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata:ide: Fix udma timings of pdc202xx_old
 controllers
Message-ID: <20090918002322.54099f94@lxorguk.ukuu.org.uk>
In-Reply-To: <8b5805ff0909171602v3dc10db9i5920be3a2abf2e04@mail.gmail.com>
References: <8b5805ff0909171602v3dc10db9i5920be3a2abf2e04@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 16:02:31 -0700
"Jung-Ik (John) Lee" <jilee@google.com> wrote:

> From: John(Jung-Ik) Lee <jilee@google.com>
> 
> Fix udma timings of pdc202xx_old controllers.
> MB=1, MC=1 (0x20, 0x01) for all UDMA modes of pdc2026{57}.

On what documentation is this based ?

Alan
