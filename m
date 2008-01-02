Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbYABFdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbYABFdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 00:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYABFdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 00:33:35 -0500
Received: from po-out-1718.google.com ([72.14.252.156]:35527 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYABFde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 00:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=M/DatkaM4J5ow+juyYvdt3OebDYLhTOd2yHoegR+0B7XbEw7MV2vfPnIcYxzOoIMJo2bn1QjYj9VMQPMS0HEzH3NrUkgBCqppvf4DOM/1hwSFzwjl55/iKkuR1ASUTtAtjlYZPMCGNI0o+Wg6NFh0N+47byxs6Rg+6ae+Frh6qI=
Date: Wed, 2 Jan 2008 13:33:42 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Abdel <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux 0.01 released
Message-ID: <20080102053342.GB2493@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <60d29d630801011256r300cb0e4l46293ab48ac5b8ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60d29d630801011256r300cb0e4l46293ab48ac5b8ed@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 09:56:59PM +0100, Abdel wrote:
>Hello everybody and happy new year,
>
>
>I have ported linux 0.01 to gcc-4.x, and bach-3.2 (and few others
>programs) can run on it.
>
>so you will find binary Image of linux 0.01 floppy and qemu hdd here:
>http://draconux.free.fr/download/os-dev/linux0.01/Image/
>
>to run it on qemu :
>> qemu  -hdb hd_oldlinux.img  -fda linux-0.01-3.3.omg -boot a
>nb : also work with bochs, and I have not tested it (yet) on real computer.
>

Excellent work! Thank you!

I think this work is useful for teaching OS newbies. So I will
forward this mail to the professors of our CS dept..

Thanks again and happy new year!

 Cong

