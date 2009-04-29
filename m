Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbZD2MIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbZD2MIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZD2MIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:08:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:50776 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbZD2MIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:08:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YH3ifhaDqZ70UGOpY+72ExsCG7D6aKJszEjUm38YlfwdhgFlSqsirGnF2VP9IE3/8h
         pYf6E9nno2ZZOl796w3lLawG7sHap3iBFDNdQPpW3UuAfjsQt3oWO87pGVWftGZFGuFB
         PC+6FmKC4YLeBUnkD70Orz06UyzZJsLpSBdd4=
MIME-Version: 1.0
In-Reply-To: <20090429040810.GI23062@kroah.com>
References: <200904271943.40588.david-b@pacbell.net>
	 <20090429040810.GI23062@kroah.com>
Date: Wed, 29 Apr 2009 20:08:10 +0800
Message-ID: <d82e647a0904290508l1b313389qcaf41c5d10f9abcd@mail.gmail.com>
Subject: Re: [patch 2.6.30-rc3] platform_bus: remove "which platform_data?" 
	confusion
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/29 Greg KH <greg@kroah.com>:
>
> Ming, what do you think of this?

I did not know platform_data field can be used in other bus , so please
revert the previous patches.

Thanks!

-- 
Lei Ming
