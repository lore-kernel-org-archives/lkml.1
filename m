Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbXLYRfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbXLYRfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 12:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXLYRfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 12:35:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:35920 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbXLYRfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 12:35:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uRR2/EQVgbpQJCrDi2JR8lCSGgXKJGbIJNhKLkj9tfG5iR6sGk59S2Ml3NMqRjs4iAWsB2SIvS1xJtI2yuzAKyfvnQNelKJQSTs0gxjrh7Vnu12r+JC1zPoYJB85fWcdf8pIh0mw29H96RHIM+AIX96hgOcY8tg3w4VXjbOcOrI=
Message-ID: <9e0cf0bf0712250935m57b36328h91bdcd45eee5987e@mail.gmail.com>
Date: Tue, 25 Dec 2007 19:35:38 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [MIPS] MEM_SDREFCFG is not defined for Alchemy DB1550 (compile fail)
Cc: linux-mips@ftp.linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
       "Ralf Baechle" <ralf@linux-mips.org>
In-Reply-To: <47713B7A.9050102@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e0cf0bf0712230733o3dfd54fcp4962ebf3f84cdff@mail.gmail.com>
	 <4770DE51.5000205@ru.mvista.com>
	 <9e0cf0bf0712250904t213d623bp977db54b6be5e3e@mail.gmail.com>
	 <47713B7A.9050102@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/07, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> > So suspend modes on these boards are not supported?
> > Only "Always On" configuration is supported?
>
>     Sleep mode is supported according to the code. But as I've said PM bits
> haven't been maintained -- probably since the submission.

Thanks!
Will it be maintained? Are there any plans?
Is there, a missing features list (TODO)?
Or this is completely unsupported board?

Best Regards,
Alon Bar-Lev.
