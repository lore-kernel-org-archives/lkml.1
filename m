Return-Path: <linux-kernel-owner+w=401wt.eu-S937123AbYEUT4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937123AbYEUT4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760693AbYEUT41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:56:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759998AbYEUT40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:56:26 -0400
Date: Wed, 21 May 2008 15:55:59 -0400
From: Rik van Riel <riel@redhat.com>
To: Tarkan Erimer <tarkan@netone.net.tr>
Cc: Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Suggestion About Kernel Releases
Message-ID: <20080521155559.11f880d1@bree.surriel.com>
In-Reply-To: <48342ADC.3030509@netone.net.tr>
References: <48341ED5.7060508@netone.net.tr>
	<20080521063855.0bdb441c@infradead.org>
	<48342ADC.3030509@netone.net.tr>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 16:59:56 +0300
Tarkan Erimer <tarkan@netone.net.tr> wrote:

> Even, Linus can releases new kernels more quickly. Because, testing
> purpose should be handled by someone else like Chris did for 2.6.x.y.

If Linus were to go straight from merge window to merge window,
with stabilization happening in parallel, then there would be
no stable basis at the start of each merge window and bugs can
just pile up.

Speeding things up could lead to the same kind of code quality
issues we used to have in the 1.3, 2.1, 2.3 and 2.5 kernel series.

Slowing down regularly is good, not bad.

-- 
All rights reversed.
