Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYENUzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYENUzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYENUyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:54:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbYENUyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:54:50 -0400
Date: Wed, 14 May 2008 13:54:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: harvey.harrison@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] ide: use the common ascii hex helpers
Message-Id: <20080514135421.03e14465.akpm@linux-foundation.org>
In-Reply-To: <200805142248.22642.bzolnier@gmail.com>
References: <1210619136.24092.54.camel@brick>
	<200805142248.22642.bzolnier@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 22:48:22 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Monday 12 May 2008, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

I actually dropped this one because the code it's patching isn't
there any more.
