Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbYEFTvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbYEFTvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763435AbYEFTub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:50:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762778AbYEFTu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:50:29 -0400
Date: Tue, 6 May 2008 15:47:58 -0400
From: Rik van Riel <riel@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 8/8] guest page hinting light
Message-ID: <20080506154758.498b25b2@cuia.bos.redhat.com>
In-Reply-To: <20080506155112.820321745@de.ibm.com>
References: <20080506155027.974409738@de.ibm.com>
	<20080506155112.820321745@de.ibm.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 17:50:35 +0200
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Use the existing arch_alloc_page/arch_free_page callbacks to do
> the guest page state transitions between stable and unused.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All Rights Reversed
