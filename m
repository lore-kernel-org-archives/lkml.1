Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbYEFQHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbYEFQHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbYEFQEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:04:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:22039 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765240AbYEFQEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:04:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UOQ5EVQ+08MsNgro81mklicj56qVi84xx9BzKeJ4WwCLw+Plu5xmyYYldxaAExz01MQDhFdUNlBjpytx2rFTCwb/7KhmDgehczV1f/V3DFkSNGzRM9XwI6086Ly3oT9/VKG2Rby5EM6BmWLIMlYJWBSJFHbFKJdQrojwKYUNW4k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] SWARM IDE: Fix up following changes to ide_hwif_t
Date: Tue, 6 May 2008 17:58:31 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.55.0805060031350.7061@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805060031350.7061@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061758.31671.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2008, Maciej W. Rozycki wrote:
>  Following recent changes to ide_hwif_t update the SWARM IDE driver to use 
> hw_regs_t to initialize port mapping.  Plus minor layout adjustments along 
> the lines of other drivers.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>

thanks, applied
