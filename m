Return-Path: <linux-kernel-owner+w=401wt.eu-S1761112AbYGOCEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761112AbYGOCEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYGOCEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:04:24 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:15250 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbYGOCEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W0jA5vl58qSpXeQxMBzEZEtGFui8kirZdVYHjpi6Klj0DWO89IG6wZJzqYVSEjBYPi
         0h2FBc27KhlMmVc0BqDRBMdp8wbEZ7oWNcNHfffVS15VQZ77nZZxnasEdewBeEk3541b
         icDWnsvD/FMid0lFApOOnFVWEoJW5zzqwsXOQ=
Message-ID: <dd18b0c30807141904i5646f35fq8b0a382bd3ec05c@mail.gmail.com>
Date: Tue, 15 Jul 2008 02:04:22 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080715020010.GA18099@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080715020010.GA18099@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 2:00 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>   I am seeing the same boot failure on a second generation
> MacBook Pro with both the kernel-2.6.26-136 srpm built on
> Fedora 9 as well as with a stock unpatched linux 2.6.26 build
> using the .config from the fedora 9 build. The boot process always
> hangs with the errors...
>
>  pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
>  pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
>
> Could someone else try booting 2.6.26 on a second generation MacBook Pro?
>                             Jack
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

everything seems o.k. here with 2.6.26-rc9 on a macbook2,2

-- 
Justin P. Mattock
