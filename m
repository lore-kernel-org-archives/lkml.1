Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbZLPSXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbZLPSXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762766AbZLPSXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:23:34 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:44059 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762738AbZLPSXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:23:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=RXmAGDTLjXN/xMzpxRhh61W2UBJzlX0R/tR2c2eWTlCFHURhRo2D797NkI3ZSzJFvv
         dOaDFLeBF+tTPyss7Bfs2OqzvBkQ61hz6D75PiUiFXCCNoMW9xXF9S3uNAjRvYd7GLzt
         IDS3X+0IQd7nAs8CliOAaf3yS3zwx+J/Pp9Gk=
MIME-Version: 1.0
In-Reply-To: <1260980883-30030-1-git-send-email-nicolas.ferre@atmel.com>
References: <1260980883-30030-1-git-send-email-nicolas.ferre@atmel.com>
Date: Wed, 16 Dec 2009 11:23:31 -0700
X-Google-Sender-Auth: caa8a03fd68412ee
Message-ID: <e9c3a7c20912161023ta19f0b3qe32899e27d0875d1@mail.gmail.com>
Subject: Re: [PATCH] dma: at_hdmac: correct incompatible type for argument 1 
	of 'spin_lock_bh'
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, maciej.sosnowski@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 9:28 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Correct a typo error in locking calls.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Applied, and added stable@kernel.org to the cc.

--
Dan
