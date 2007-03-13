Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbXCMCg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbXCMCg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 22:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXCMCg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 22:36:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:36857 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbXCMCg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 22:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qhgOkvfxb73PU+TU2QMoMJzBozkWvQkBpmDnA5QYYm2D+JCj7OF2f+aor/Pbw0OWh4HVZfv2wWrdboVmjLeY90GgfdBudwf7ufPCUMR83ytDe7oFYYmpluoDbmtSxQRh03oqZvLSS2BQm4BBAEcZWeXJbFikmBZgR3wd7Du4gYQ=
Message-ID: <3aac340703121936k51df425dg7e1a74688a67075@mail.gmail.com>
Date: Tue, 13 Mar 2007 04:36:52 +0200
From: Vitaliyi <imgrey@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: Fwd: libata extension
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <200703122106.39669.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3aac340703102322p362998b9labedc13503702d2b@mail.gmail.com>
	 <3aac340703121003l43685599t8dbffe6247879a91@mail.gmail.com>
	 <3aac340703121007q35c7acf7t648e0ed7608be04d@mail.gmail.com>
	 <200703122106.39669.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is the access to Control register needed?

To execute soft reset for example.

> > In the perfect case i would like to be able to execute vendor command
> > set (reverse engineered).
>
> Sounds interesting. :-)
>
> Could you give some more details on what are you going to implement?

Reading/writing service area, uploading, downloading modules, working
with flash etc.
