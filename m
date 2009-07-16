Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZGPL7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZGPL7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 07:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZGPL7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 07:59:53 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35033 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbZGPL7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 07:59:52 -0400
Date: Thu, 16 Jul 2009 05:59:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Message-ID: <20090716115952.GR24310@parisc-linux.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247701438-18266-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 12:43:55AM +0100, Matthew Garrett wrote:
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index b62a097..b099493 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -421,6 +421,7 @@ struct scsi_host_template {
>  	 */
>  	unsigned unchecked_isa_dma:1;
>  
> +
>  	/*
>  	 * True if this host adapter can make good use of clustering.
>  	 * I originally thought that if the tablesize was large that it

Spurious hunk ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
