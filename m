Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYANVmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYANVmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYANVlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:41:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:64914 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYANVly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:41:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AChWPFV7CuEMeZvCMZHrU2yFnbKQzmun3g1KZIJo8tSJom9JeY40r/Hn21SydOLsckxK2yE/z5TvOg+LUgiy0hryI4jBCGgT47rcSEkxMUz/AE/xQU0czEDFGF5aF672THMchb46gwGibthP2p7avY4KXekfY9/CHeb2+CifnvA=
Message-ID: <6101e8c40801141341hcb17b08h2fd5244bccb21928@mail.gmail.com>
Date: Mon, 14 Jan 2008 22:41:52 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [BUG] skge 0000:02:05: read data parity error
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@suse.de
In-Reply-To: <20080114213453.GJ9847@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40801141157j1ce7d3f0if2e4eb2344b6c844@mail.gmail.com>
	 <20080114125200.28cb4c69@deepthought>
	 <20080114210105.GG9847@does.not.exist>
	 <6101e8c40801141331n3cb66c04pc74ff07faf04c8fd@mail.gmail.com>
	 <20080114213453.GJ9847@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/08, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Jan 14, 2008 at 10:31:03PM +0100, Oliver Pinter (Pintér Olivér)
> wrote:
> > I think, it is a potential security breakpoint, when applications with
> > root permission its read, then a machine is freezed, or only i thin
> > it's?
>
> When you are root there are infinite ways to kill your machine, so
> there's nothing security related about this issue.

Yes, i know, but when some application or daemons read some file with
running root privileges, then ...


thanks, then it is only a "feature" and not bug.
>
> > Thanks,
> > Oliver
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>


-- 
Thanks,
Oliver
