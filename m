Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbYJESKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbYJESKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 14:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYJESKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 14:10:34 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:21299 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180AbYJESKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 14:10:34 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 14/19] parport: quickfix the proc registration bug
Date: Sun, 5 Oct 2008 20:10:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20081005163302.3799.61899.stgit@localhost.localdomain> <20081005163302.3799.61899.stgit@localhost.localdomain> <20081005163758.3799.88465.stgit@localhost.localdomain>
In-reply-To: <20081005163758.3799.88465.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810052010.29315.elendil@planet.nl>
X-OriginalArrivalTime: 05 Oct 2008 18:10:30.0111 (UTC) FILETIME=[A6AFDEF0:01C92715]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Ideally we should have a directory of drivers and a link to the 'active'
> driver. For now just show the first device which is effectively the
> existing semantics without a warning.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

I tested this patch, but it did not fix the issue [1].
Should it still be included?

Cheers,
FJP

[1] http://lkml.org/lkml/2008/9/27/72
