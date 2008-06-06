Return-Path: <linux-kernel-owner+w=401wt.eu-S1761670AbYFFRHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761670AbYFFRHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 13:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYFFRGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 13:06:55 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:34444 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYFFRGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:06:54 -0400
Date: Fri, 6 Jun 2008 10:06:53 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Andrew Vasquez <linux-driver@qlogic.com>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org
Subject: Re: [patch -v3 22/22] qla2xxx: use memory_read_from_buffer
Message-ID: <20080606170653.GC388@plap4-2.local>
References: <20080604115633.116832712@gmail.com> <20080604115859.351267641@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604115859.351267641@gmail.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 06 Jun 2008 17:06:47.0355 (UTC) FILETIME=[B429D8B0:01C8C7F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2008, Akinobu Mita wrote:

> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Andrew Vasquez <linux-driver@qlogic.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |   45 ++++++++--------------------------------
>  1 file changed, 10 insertions(+), 35 deletions(-)

Basic testing looks good.  Thanks.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
