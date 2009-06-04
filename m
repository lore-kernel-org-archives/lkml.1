Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZFDTI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZFDTI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZFDTIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:08:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbZFDTIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:08:20 -0400
Date: Thu, 4 Jun 2009 12:07:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, jack@suse.cz,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-Id: <20090604120726.708a2211.akpm@linux-foundation.org>
In-Reply-To: <20090604152040.GA6007@nowhere>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
	<20090604152040.GA6007@nowhere>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 17:20:44 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> I've just tested it on UP in a single disk.

I must say, I'm stunned at the amount of testing which people are
performing on this patchset.  Normally when someone sends out a
patchset it just sort of lands with a dull thud.

I'm not sure what Jens did right to make all this happen, but thanks!
