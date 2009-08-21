Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZHUKph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZHUKph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 06:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZHUKph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 06:45:37 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:37896 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbZHUKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 06:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=gQU9TbgRwWK/VyLssgg1g1CVOAtBEmJEmpD7encC11hu48OwetlPet2xsOM8ELeWD3
         5BWfNNp0BFfDks6nCf5wetWXp5kWGAZDIP1m/VWfKGVDosbuYPn5AN5UmRITQ3EqL41w
         LTlOBBUZDPixlJEGZjlyf9VPY+sdP6uEWRRIo=
Date: Fri, 21 Aug 2009 12:45:33 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: mmi@superbash.de
Cc: linux-kernel@vger.kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
       r.marek@assembler.cz
Subject: Re: AMD K10 temp.module ready since months, but missing in
 kernel...
Message-ID: <20090821104533.GA3872@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	mmi@superbash.de, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>, r.marek@assembler.cz
References: <20090821001322.470bb177@p4laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090821001322.470bb177@p4laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding relevant CCs ]

On Fri, Aug 21, 2009 at 12:13:22AM +0200, mmi wrote:
> Hello out there,
> 
> i found the code to read temperature of AMD K10 (Phenom) processors a
> couple of months ago in the net (GPL). I use it since January now and i
> wonder, why it's not in the kernel till now.
> 
> It's from the same author, who wrote k8temp.c (which is in kernel).
> 
> Thanks,
> 
> M. Miederer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
