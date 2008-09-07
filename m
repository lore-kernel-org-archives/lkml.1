Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYIGS1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYIGS1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 14:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYIGS11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 14:27:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:5477 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbYIGS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 14:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Rz9cGy4QgZ7FYqiAbW1+UNOPGFj3xO6ETglnsuZjRRE1DkvFKaupqD1yeED99DzwwZ
         hmRYOTC0Frt1BT9NH08eHjrNKKg4T2jGknVbhGSIyNNhiHa2bEUyKFFIkCeXP4PJZ6bd
         LYTGtmbuOfh+L5EzqOC1DS/EsPsGrdjQPOSbE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] ide/Kconfig: mark ide-scsi as deprecated
Date: Sun, 7 Sep 2008 20:10:07 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200809031943.55605.bzolnier@gmail.com> <200809051938.24933.bzolnier@gmail.com> <20080906214318P.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080906214318P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809072010.07998.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 September 2008, FUJITA Tomonori wrote:

[...]

> Ok, I'll take care of it if you like.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] add deprecated ide-scsi to feature-removal-schedule.txt
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks, applied.
