Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbYAYVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbYAYVEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYAYVEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:04:33 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:20941 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYAYVEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:04:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S1rb6dvBQ+9ALonCsvteGEibIh3+jqtfkAiCTTtKQpREEhbAObJFtHB5SlfDhPNviZy2lMunm/zobfyBpfar9OJsL9C1bkObyDQfW09HJdxlP3mMI+V49v2T2+UoMq0oAxPiI0LvDHNXtvQ1V2/N4rfo2KhaRB8z+yjWSiBI+GM=
Message-ID: <9f00bd9d0801251304hbc9f498xfad3e73dc42d16ec@mail.gmail.com>
Date: Fri, 25 Jan 2008 23:04:30 +0200
From: "Filippos Papadopoulos" <psybases@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: INITIO scsi driver fails to work properly
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, cebbert@redhat.com, bharrosh@panasas.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1201279772.3119.38.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200070903.3286.28.camel@localhost.localdomain>
	 <9f00bd9d0801130428s5e4c034apf21052b918470f99@mail.gmail.com>
	 <1200410166.9273.4.camel@localhost.localdomain>
	 <20080116145916A.fujita.tomonori@lab.ntt.co.jp>
	 <1200495471.3136.1.camel@localhost.localdomain>
	 <20080121222037.3d8b46a1@lxorguk.ukuu.org.uk>
	 <9f00bd9d0801220950r49de29abl8fbb2495a65c9a10@mail.gmail.com>
	 <1201279772.3119.38.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/08, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
>
> Actually, I suspect your issues should be fixed by this patch:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e2d435ea4084022ab88efa74214accb45b1f9e92
>
> Could you download 2.6.24 and try it out to see if they are?
>
> Thanks,
>
> James
>


Well, 2.6.24 fixes the problem.
Thanks to all of you!
