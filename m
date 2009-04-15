Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbZDOEPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbZDOEPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZDOEP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:15:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:46307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZDOEP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:15:28 -0400
Message-ID: <49E55EF6.2070007@kernel.org>
Date: Wed, 15 Apr 2009 13:13:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH 1/5] mmap: don't assume f_op->mmap() doesn't change vma->vm_file
References: <1239674662-31318-1-git-send-email-tj@kernel.org> <1239674662-31318-2-git-send-email-tj@kernel.org>
In-Reply-To: <1239674662-31318-2-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 04:13:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is dropped as per Hugh Dickins' comment.

Thanks.

-- 
tejun
