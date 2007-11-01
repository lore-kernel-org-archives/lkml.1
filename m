Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbXKAWQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbXKAWQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXKAWQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:16:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39682 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbXKAWQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:16:04 -0400
Date: Thu, 1 Nov 2007 16:16:04 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] debloat aic7xxx and aic79xx drivers
Message-ID: <20071101221604.GB19914@parisc-linux.org>
References: <200710141558.27156.vda.linux@googlemail.com> <200710141600.10468.vda.linux@googlemail.com> <200710141601.08946.vda.linux@googlemail.com> <200710141602.16283.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710141602.16283.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 04:02:15PM +0100, Denys Vlasenko wrote:
> Adds more consts

error: patch failed: drivers/scsi/aic7xxx/aic79xx.h:1328
error: drivers/scsi/aic7xxx/aic79xx.h: patch does not apply
error: patch failed: drivers/scsi/aic7xxx/aic7xxx.h:1145
error: drivers/scsi/aic7xxx/aic7xxx.h: patch does not apply

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
