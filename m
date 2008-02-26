Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbYBZTsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbYBZTsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYBZTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:48:46 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4993 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751371AbYBZTsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:48:45 -0500
Message-ID: <47C46CBE.3070006@panasas.com>
Date: Tue, 26 Feb 2008 11:47:10 -0800
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Pete Wyckoff <pw@osc.edu>, Roland Dreier <rdreier@cisco.com>,
       Olaf Kirch <olaf.kirch@oracle.com>, general@lists.openfabrics.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "IB/fmr_pool: ib_fmr_pool_flush() should flush
 all dirty FMRs"
References: <20080225225330.GA3316@osc.edu> <ada1w70zlkf.fsf@cisco.com> <20080226182655.GD7033@osc.edu> <20080226182731.GE7033@osc.edu> <47C46715.2090603@panasas.com> <20080226193901.GD6029@parisc-linux.org>
In-Reply-To: <20080226193901.GD6029@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2008 19:47:11.0946 (UTC) FILETIME=[612522A0:01C878B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diabolical ;-)
Thanks for the pointer!

Benny

On Feb. 26, 2008, 11:39 -0800, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Feb 26, 2008 at 11:23:01AM -0800, Benny Halevy wrote:
>> Pete, the subject says "PATCH 1/2" but I didn't see any follow-up message
>> for PATCH 2/2. Just wondering :)
> 
> I think the problem's on your end ... I got it and so did marc:
> http://marc.info/?l=linux-scsi&m=120405067313933&w=2
> 

