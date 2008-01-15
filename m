Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbYAOLRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbYAOLRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 06:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYAOLRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 06:17:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYAOLRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 06:17:08 -0500
Date: Tue, 15 Jan 2008 11:17:04 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [RFC] A SCSI fault injection framework using SystemTap.
Message-ID: <20080115111704.GJ8075@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <478C22A9.5000009@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478C22A9.5000009@ce.jp.nec.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 12:04:09PM +0900, K.Tanaka wrote:
>   -dm-mirror's redundancy doesn't work. A read error from the disk consisting
>    the array will be directory passed to the userspace, without reading from
>    the other mirror.
>    (It turns out that this issue is a known issue, but the patch is not merged.
>     http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-raid1-handle-read-failures.patch)
 
It's in the queue for 2.6.25.

Alasdair
-- 
agk@redhat.com
