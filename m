Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYIPB0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYIPB0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 21:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYIPB0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 21:26:10 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53562 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYIPB0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 21:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:x-url:user-agent:sender;
        b=Pbkb6ers6dU6viSSHfWcyHkLwWz/zZn12hTeyiD13G169wNG0cPSETMF4QXv0y0Ud9
         kNVwTL/EAXrxV+RYg4JzOYYWfBulTMi43/LmSv47oR3u6eGbPgHi6oJdd97/Vjh4n9Az
         crLH3NG0IAqRJhRRLHbVgOZ7QJGH+UFXMRnJk=
Date: Mon, 15 Sep 2008 22:18:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Rewrite Linux Makefile name
Message-ID: <20080916011836.GD8702@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <20080916002613.GG15421@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080916002613.GG15421@havoc.gtf.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 15, 2008 at 08:26:13PM -0400, Jeff Garzik escreveu:
> 
> This is yet another test patch.  It kicks ass, eh?
> 
> Not-signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> diff --git a/Makefile b/Makefile
> index 4ff83ea..7d06a3e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -2,7 +2,7 @@ VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 27
>  EXTRAVERSION = -rc6
> -NAME = Rotary Wombat
> +NAME = Patch Wombat Numero Dos

Remendo número três! Next language por supuesto! :-P

- Arnaldo
