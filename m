Return-Path: <linux-kernel-owner+w=401wt.eu-S1762294AbYBZTjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762294AbYBZTjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761023AbYBZTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:39:05 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:47966 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYBZTjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:39:03 -0500
Date: Tue, 26 Feb 2008 12:39:02 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Pete Wyckoff <pw@osc.edu>, Roland Dreier <rdreier@cisco.com>,
       Olaf Kirch <olaf.kirch@oracle.com>, general@lists.openfabrics.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "IB/fmr_pool: ib_fmr_pool_flush() should flush all dirty FMRs"
Message-ID: <20080226193901.GD6029@parisc-linux.org>
References: <20080225225330.GA3316@osc.edu> <ada1w70zlkf.fsf@cisco.com> <20080226182655.GD7033@osc.edu> <20080226182731.GE7033@osc.edu> <47C46715.2090603@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C46715.2090603@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:23:01AM -0800, Benny Halevy wrote:
> Pete, the subject says "PATCH 1/2" but I didn't see any follow-up message
> for PATCH 2/2. Just wondering :)

I think the problem's on your end ... I got it and so did marc:
http://marc.info/?l=linux-scsi&m=120405067313933&w=2

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
