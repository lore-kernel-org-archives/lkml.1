Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbXCaNL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbXCaNL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 09:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXCaNL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 09:11:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:33549 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbXCaNL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 09:11:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p0H04YHJ+Fs1P+EZqAKvwS6RXyUpDD1FZ0YN1bVMxKr/3++GlSYwWuthUoAJvU/WfOX8SmVAUyIJftp/me6feaDkqcmuZGwFFGrjTTkeVE19LvRwA1NKlS4xWw+tiULOVWc4uj81YjU9q028L8NZco0BwTjW3569oyVbU5gm/qU=
Message-ID: <6bffcb0e0703310611n1538113fge49a46785f055369@mail.gmail.com>
Date: Sat, 31 Mar 2007 15:11:56 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: Fw: Re: 2.6.21-rc5-mm3
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jan Beulich" <jbeulich@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <460E43D2.70504@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070330103958.16b738aa.akpm@linux-foundation.org>
	 <200703302131.23469.ak@suse.de> <460E43D2.70504@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > Were there any strange binutils in use, Michal?
>
> I don't remember when I had problems with this compiler.
    ^^^
(sorry, to many bottles of beer)

ld --version
GNU ld version 2.17.50.0.6-2.fc6 20061020

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
