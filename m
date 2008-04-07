Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbYDGSCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbYDGSCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbYDGSCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:02:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:24506 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYDGSCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=txEkzpIxdQavE8+XswzqAthrnD++qxVk1CbAR4Qimmq4sqYTO/YJTEhgcc0iMj9UXDbIptYUZf6Tj2xBDqK4zBbuVVYArNgsAFzw3g1Jaqf3H+UDr6gVbu0tLHG7GchhLkipPF/6PQKxIFURLsrf+85edm8yORiMmMVJ+KKx+/o=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] debloat aic7xxx and aic79xx drivers
Date: Mon, 7 Apr 2008 20:01:37 +0200
User-Agent: KMail/1.8.2
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200803230440.40685.vda.linux@googlemail.com> <200803230441.22926.vda.linux@googlemail.com> <47F9F7FD.908@suse.de>
In-Reply-To: <47F9F7FD.908@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804072001.37951.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2008 12:31, Hannes Reinecke wrote:
> Hi Denys,
> 
> Denys Vlasenko wrote:
> > Deinlines and moves big functions from .h to .c files.
> > Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> > --
> > vda
> Patch looks good to me.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Thanks! Please, queue it up in linux-scsi tree.
--
vda
