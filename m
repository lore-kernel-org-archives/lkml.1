Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYCCPUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYCCPUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYCCPTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:19:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:9791 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbYCCPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:19:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LM97JR1vj64y381RYHf22DAMrJyS5VE9tnQghPtRXUE6Ac/cyMpArHslpOQ5xtkqqN1u/KqOBCYIhsZEgu7nB+ESsYXMELWwXyeCZXNsIQI194DBKOfIJ8RGlzGXqWm1me85/sE5bvKTiZpU2dhh/erbl/K6MeZZ6RQwqiTDrF0=
Message-ID: <6101e8c40803030719v3d19e9acg7f9714fc9f6c7a37@mail.gmail.com>
Date: Mon, 3 Mar 2008 16:19:30 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86: potential ioremap() issues
Cc: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20080303104407.GD21190@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C6BE37.76E4.0078.0@novell.com> <20080228132404.GB18551@elte.hu>
	 <6101e8c40802291404u49037ad9u4347f552ce72bf28@mail.gmail.com>
	 <20080303104407.GD21190@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks

On 3/3/08, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Oliver Pinter <oliver.pntr@gmail.com> wrote:
>
> > Hi Ingo!
> >
> > this patch is needed for 2.6.22 kernel? I see, this code in
> > arch/x86_64/mm/ioremap.c
>
> no, should not be needed - these are extra warnings in .25.
>
> 	Ingo
>


-- 
Thanks,
Oliver
