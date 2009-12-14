Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZLNKKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZLNKKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbZLNKKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:10:13 -0500
Received: from 8bytes.org ([88.198.83.132]:59521 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbZLNKKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:10:13 -0500
Date: Mon, 14 Dec 2009 11:10:09 +0100
From: Joerg Roedel <joro@8bytes.org>
To: re.emese@gmail.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, jens.axboe@oracle.com
Subject: Re: [PATCH 0/3] Constify struct block_device_operations for
	2.6.32-git-053fe57ac v2
Message-ID: <20091214101009.GA23742@8bytes.org>
References: <cover.1260662995.git.re.emese@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 12:59:19AM +0100, re.emese@gmail.com wrote:
> The following patch series attempts to constify several structures
> that hold function pointers. This is only the initial batch, there
> are about over 150 candidate structures, some of which can be
> constified as well, I plan to submit them in the future.

Beside the fact that you posted two patch series in one thread all your
patches lack a commit message. Please fix that.

	Joerg

