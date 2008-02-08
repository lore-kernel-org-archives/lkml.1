Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbYBHVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbYBHVqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbYBHVqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:46:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38932 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758210AbYBHVqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:46:11 -0500
Date: Fri, 8 Feb 2008 13:45:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <liml@rtr.ca>
Cc: Yinghai.Lu@Sun.COM, jgarzik@redhat.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, saeed@marvell.com
Subject: Re: [PATCH] sata_mv: fix loop with last port
Message-Id: <20080208134501.4222995e.akpm@linux-foundation.org>
In-Reply-To: <47ABDAF2.7030209@rtr.ca>
References: <200802071506.17459.yinghai.lu@sun.com>
	<47ABDAF2.7030209@rtr.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 23:30:42 -0500
Mark Lord <liml@rtr.ca> wrote:

> > Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> ..
> 
> Yup, obvious bug fixes, thanks.
> Signed-off-by: Mark Lord <mlord@pobox.com>

Typically we'll use Acked-by: here.  Because Signed-off-by: implies that
you were in the delivery path, or that you worked on the patch.  afacit
that is not the case.  Documentation/SubmittingPatches has some explanation.

I made that change to my copy of the patch - please let me know if that
was incorrect, thanks.
