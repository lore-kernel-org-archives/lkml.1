Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbXLUTsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbXLUTsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 14:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbXLUTr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 14:47:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:22974 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbXLUTrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 14:47:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ZbP0IvNU6nAPFCSFs/sv+ydw1QmLvKjlEI/VhVrrOuQzdzidJKlXbh2OAzDKtJu0YCb8EY1286yUGLQMCP/ocGeySflwJMvdV0XHUSyillFv1Bw8YzjG/M/j3mzioPiENigxa5BXY1YgarYqkiJxGKSGVt1MLdapoO5Xo97AM3A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH 00/63] ide-cd: redux
Date: Fri, 21 Dec 2007 20:57:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200712200148.49690.bzolnier@gmail.com> <476ACFE5.2060800@cfl.rr.com>
In-Reply-To: <476ACFE5.2060800@cfl.rr.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712212057.56942.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007, Phillip Susi wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> > 
> > This patch series is a major rework of the ide-cd driver.
> 
> Hi, in the future could you please post big patchbombs like this as 
> replies to the first one so they fold nicely into one thread?  IIRC, 
> git-send-email does this by default now.

Sure, sorry for forgetting about it this time.

Bart
