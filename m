Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0CBAQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 19:16:30 -0500
Received: from THUNK.ORG ([69.25.196.29]:60145 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab0CBAQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 19:16:29 -0500
Date: Mon, 1 Mar 2010 19:16:25 -0500
From: tytso@mit.edu
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext4: Change check for choosing group/file preallocation.
Message-ID: <20100302001625.GA6077@thunk.org>
Mail-Followup-To: tytso@mit.edu, Tao Ma <tao.ma@oracle.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1267171522-17439-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267171522-17439-1-git-send-email-tao.ma@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, this patch makes sense.  I've added it to the ext4 patch
queue.

					- Ted
