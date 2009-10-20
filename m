Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbZJTAzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbZJTAzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbZJTAzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:55:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55649 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbZJTAzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:55:07 -0400
Date: Tue, 20 Oct 2009 02:55:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 2/5] cfq-iosched: preparation to handle multiple
	service trees
Message-ID: <20091020005511.GC10727@kernel.dk>
References: <200910192221.15739.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910192221.15739.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19 2009, Corrado Zoccolo wrote:
> We embed a pointer to the service tree in each queue, to handle multiple
> service trees easily.
> Service trees are enriched with a counter.
> Queues are enriched with a back pointer to their context.

Looks good.

-- 
Jens Axboe

