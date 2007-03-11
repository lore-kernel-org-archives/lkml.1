Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbXCKAnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbXCKAnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 19:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXCKAnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 19:43:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:28649 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbXCKAnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 19:43:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ka9wNh9SCW0betyYi65YKKzbOnfVUQCePpTWojANL+v0omV/oplrnJ0WHXidScgXmaItzRrgMi7Z64BOD2nX/1A3uTktG1/prkXuOhTqlp0KXkLWOQ7s3xFXgK9dNS+Ju89C0NwKWA88BY3vvVgAKyjQ4Hh1HTC4HFQT0bl14oM=
Message-ID: <7d01f9f00703101643u572035fcp9185ab43e82b20d2@mail.gmail.com>
Date: Sun, 11 Mar 2007 01:43:45 +0100
From: "Thibaut VARENE" <T-Bone@parisc-linux.org>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [ck] Re: RSDL v0.28 for 2.6.20
Cc: "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200703111054.42921.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703101845.59497.kernel@kolivas.org>
	 <45F2F45F.6000403@seclark.us> <20070310191118.GL943@1wt.eu>
	 <200703111054.42921.kernel@kolivas.org>
X-Google-Sender-Auth: 990cc82eff97920d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/07, Con Kolivas <kernel@kolivas.org> wrote:

> Has anyone had any trouble with RSDL on the stable kernels (ie not -mm)?

Tested fine so far on ppc, ia64 and (mostly) parisc.

HTH

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/
