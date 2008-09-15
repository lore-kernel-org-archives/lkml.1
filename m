Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYIORwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYIORwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYIORwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:52:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:6348 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbYIORwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=eav8yB5dshazoQo49WUkQkMGqKsNcoQTCls/iLMnIgm2ClM0qH98VMZg8WcjVKgYcH
         bw+H+VyBUDiAYw4hg2QFflerc0QuMO9TBaSFkiR8WnGyqYwLJOjVZ31MO6H/e9ZVkh3O
         tcT7Aoep3ggc+RewWWCgw8p3/2MPctIZ7rSBs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 01/10] ide: add ide_drive_t.dma flag
Date: Mon, 15 Sep 2008 19:51:46 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com> <1221392158-3848-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1221392158-3848-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809151951.47573.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2008 13:35:49 Borislav Petkov wrote:
> This flag is to accomodate ide-cd functionality into ide atapi.
> 
> There should be no functionality change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
