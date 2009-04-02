Return-Path: <linux-kernel-owner+w=401wt.eu-S933685AbZDBTib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685AbZDBTib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763970AbZDBTgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:36:41 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58010 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbZDBTgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=C7GRbzzpWFK6HzxWT6W26FBfVSQZsXXNkXkxVR+3sEw3XMmtCD7VM1M1OKw3ww0wzd
         eB8+Fu+ljs7QaKfbtW+jHnFFPnY0NQdfReS3Tgz4+PlJ/pYwQXh4hojQ/7VhNYeS8T8S
         VToYGJ4RXkmrNXLtmeGMPypiXvdZWZcj+Z5IU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] tx4939ide: remove wmb()
Date: Thu, 2 Apr 2009 21:11:15 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090401; KDE/4.2.1; i686; ; )
Cc: Grant Grundler <grundler@google.com>, linux-ide@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
References: <1238516136-15852-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1238516136-15852-1-git-send-email-anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022111.15347.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Atsushi Nemoto wrote:
> * define CHECK_DMA_MASK
> * remove use of wmb()
> 
> Suggested-by: Grant Grundler <grundler@google.com>
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

applied
