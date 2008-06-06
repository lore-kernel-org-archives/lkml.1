Return-Path: <linux-kernel-owner+w=401wt.eu-S1764987AbYFFQrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764987AbYFFQrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYFFQrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:47:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:16272 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbYFFQrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IB1Fr/mb7je7glfC8Gwk1ezc2ImLyWV3pL4RbEhB+zF04+l+2bw+eSyf1PAxJBK45i
         EW7kkqmn6B/78pB1oUlsFeBbv19y0lDGmk4l2obWYoF4Gj2vBMHPusRTTWrjd+kgEaw+
         3TqMCWV2OVhc/OE1kRFDOYNSYLo5R2FD6n91g=
Message-ID: <6101e8c40806060947g7d1e803cqf7134572b47daf2b@mail.gmail.com>
Date: Fri, 6 Jun 2008 18:47:08 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Willy Tarreau" <wtarreau@hera.kernel.org>
Subject: Re: Linux 2.4.36.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080606163222.GA312@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606163222.GA312@hera.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

it is the correct gitweb:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.36.y.git;a=summary

On 6/6/08, Willy Tarreau <wtarreau@hera.kernel.org> wrote:
>
> I've just released Linux 2.4.36.6.
>
> The patch and changelog will appear soon at the following locations:
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.6.bz2
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.6
>
> Git repository:
>    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git
>   http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git
>
> Git repository through the gitweb interface:
>   http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.36.y.git
>
> It only fixes a vulnerability in the netfilter ip_nat_snmp_basic module
> (CVE-2008-1673). If you don't use it, you don't need to upgrade.
>
> Willy
> --
> Summary of changes from v2.4.36.5 to v2.4.36.6
> ============================================
>
> Chris Wright (1):
>       asn1: additional sanity checking during BER decoding (CVE-2008-1673)
>
> Willy Tarreau (1):
>       Change VERSION to 2.4.36.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
