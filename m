Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYGUU0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYGUU0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYGUU00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:26:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:41558 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbYGUU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:26:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=eJxg5suMd0jpcrW2SqZKQJrQjrfeuDKMTMiDQ5km/D7iIYTcwluUDU59Eh1r5lkT8z
         OU3DygyNUyndgyY4Db1hza9QkeAJ8KDvEbaZKnb3LnjGL4VLEWepf4bYr6NrRPCLyxTt
         2y2h3VdrX7QPRTyChm5LLGebLsOOnw0cSThTA=
Message-ID: <5f6f8c5f0807211326h123d52d5lee4cd4a26fdbfdf2@mail.gmail.com>
Date: Mon, 21 Jul 2008 22:26:21 +0200
From: "Joshua C." <joshuacov@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: ACPI: ACPI_CUSTOM_DSDT_INITRD option
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/21 Ben Collins <bcollins@swissdisk.com>:
> I didn't have any problems with it either, but I would hate for some
> fuzz to keep it from getting accepted :)
>
>

I looked at it and it looks ok to me. The "fuzzy" part is stripped
down, compared to the previous version. It should be ready now.
