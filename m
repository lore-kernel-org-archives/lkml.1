Return-Path: <linux-kernel-owner+w=401wt.eu-S933890AbZFOTKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbZFOTKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZFOTK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:10:29 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:47296 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbZFOTK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CySe81JrrSFW+1sIObMcxJj7nglKibZYZqyutYx6k2EnCkbUOw2KK2KtoMwSEr5KiM
         pYv4WH1sBGjFAUsaE4KsHMPVAzDi+3nfoOP+qDMSmxMVd1zdK6I6y3gGWkpuifqj5BAM
         zn/GBcX87emEudrcDHF4Un6wcCcxUljaQIsXE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sven =?iso-8859-15?q?K=F6hler?= <sven.koehler@gmail.com>
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
Date: Mon, 15 Jun 2009 21:15:36 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090615-09548-g36158f6-dirty; KDE/4.2.3; i686; ; )
Cc: Takashi Iwai <tiwai@suse.de>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
References: <200906121344.26139.bzolnier@gmail.com> <s5htz2hes3u.wl%tiwai@suse.de> <4A369236.8070502@gmail.com>
In-Reply-To: <4A369236.8070502@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906152115.36822.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 June 2009 20:25:58 Sven Köhler wrote:
> Takashi Iwai schrieb:
> > Damn, that was buggy again.  The fixed version is below.
> 
> Seems to work fine.
> I have been listening music fir quite a few minutes - skip free.

Same here. :)
