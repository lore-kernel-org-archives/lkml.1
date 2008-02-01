Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYBAIxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYBAIxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYBAIxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:53:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:52768 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYBAIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:53:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fhR+0DGzp8t99HuAZIeqrK6gh7Lbs5Vx78z8igzpXZ6NsrEy30jzd9vCXNx4iGSHq2qhjSYZT+OO9J5CtXCDW1jps8UiL3MDTE0Yek4Xe394aS0gUSTMY21xw33fxXDDzl/NmxmP+PiE/KL016zb3WEu0kyNJru6qQjNjuJeA5E=
Message-ID: <df9815e70802010053n4565397dofd847373df522e5c@mail.gmail.com>
Date: Fri, 1 Feb 2008 16:53:31 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Rijndael Cosque" <rijcos@gmail.com>
Subject: Re: What's the status of x2APIC support in Linux kernel?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/08, Rijndael Cosque <rijcos@gmail.com> wrote:
> Hi all,
>
> I found the x2APIC spec via http://www.intel.com/products/processor/manuals/.
>
> Looks at present there is no x2APIC support in Linux kernel 2.6.24?
>
> Is there any experimental patch available for Linux kernel? -- I
> googled "x2APIC Linux";  looks no patch for now?
>
Maybe.   I have a question as well, what about the  status of I/O
xAPIC support in linux?  If it is not supported yet, is there any
effort to add it?  I'm interested in that, hopefully can take part in
the development.

Regards,
