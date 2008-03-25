Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYCYQmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYCYQmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbYCYQmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:42:10 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:33596 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757796AbYCYQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:42:08 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JYAP1N-01-JWB-01
Date: Tue, 25 Mar 2008 17:41:54 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, ak@suse.de, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Increase max physical memory size of x86_64
Message-ID: <20080325164154.GA5909@alberich.amd.com>
References: <20080321133157.GA10911@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321133157.GA10911@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Mar 2008 16:41:52.0754 (UTC) FILETIME=[21281520:01C88E97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 08:31:57AM -0500, Jack Steiner wrote:
> Increase the maximum physical address size of x86_64 system
> to 44-bits. This is in preparation for future chips that
> support larger physical memory sizes.

Shouldn't this be increased to 48?
AMD family 10h CPUs actually support 48 bits for the
physical address.


Regards,

Andreas


