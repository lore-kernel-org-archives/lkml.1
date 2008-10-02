Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbYJBE5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbYJBE5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 00:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYJBE52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 00:57:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbYJBE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 00:57:28 -0400
Date: Wed, 1 Oct 2008 21:56:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20081001215638.3a65134c.akpm@linux-foundation.org>
In-Reply-To: <20081001200034.65eb67d6@infradead.org>
References: <20081001200034.65eb67d6@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 20:00:34 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority

You proposed this a while back and it didn't happen and I forget
why and the changelog doesn't mention any of that?
