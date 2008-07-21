Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYGUUVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYGUUVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYGUUVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:21:17 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:51786 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbYGUUVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qBfuYRhgd2XnHYBxCC1NhY/svkXPYdQxBp+YIpUz048i6SSB3TjYp78wxN5mcXurNI
         EWNP0sFBmshEFileW6Joo/zdDCllgf4cnPeLzwujpQ97+p00Tkoj7G+OpwN+10NM4auc
         Bbbt3tkb17wQzhFS7Na1KyPbu3ixHih+T2wE8=
Message-ID: <5f6f8c5f0807211321o3b1db57n2cedde3f9c4efeae@mail.gmail.com>
Date: Mon, 21 Jul 2008 22:21:12 +0200
From: "Joshua C." <joshuacov@googlemail.com>
To: "Ben Collins" <bcollins@swissdisk.com>
Subject: Re: ACPI: ACPI_CUSTOM_DSDT_INITRD option
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1216670533.7585.181.camel@cunning>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5f6f8c5f0807211257j668535eam873275afc2040f73@mail.gmail.com>
	 <1216670533.7585.181.camel@cunning>
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
