Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbZKAJaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbZKAJaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 04:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZKAJaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 04:30:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:56289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbZKAJaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 04:30:23 -0500
Message-ID: <4AED5565.1030003@kernel.org>
Date: Sun, 01 Nov 2009 10:31:17 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alberto Bertogli <albertito@blitiri.com.ar>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] Fix bio_alloc() and bio_kmalloc() documentation
References: <1257031116-17934-1-git-send-email-albertito@blitiri.com.ar>
In-Reply-To: <1257031116-17934-1-git-send-email-albertito@blitiri.com.ar>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Bertogli wrote:
> Commit 451a9ebf accidentally broke bio_alloc() and bio_kmalloc() comments by
> (almost) swapping them.
> 
> This patch fixes that, by placing the comments in the right place.
> 
> Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>

Oops,

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
