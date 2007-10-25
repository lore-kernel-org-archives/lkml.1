Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbXJYSz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbXJYSz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXJYSzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:55:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:62594 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbXJYSzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BaBiEJcgft9NYk7Q776LCDUSjrcN5aQV4pwQRA8XZtrB67fZdWcApxLHkBd18sgl6756C/aeIMU7Lxyc1PO0HDl5Uhgi79buyjBSJmSgXjn+a9QLyyQ6da2qttN0EPTBdpmRFRTHpsAS+wuMzjl1q3D87voarYGq8GY3pkdqYqk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Subject: Re: Using -traditional in EXTRA_AFLAGS
Date: Thu, 25 Oct 2007 19:55:09 +0100
User-Agent: KMail/1.9.1
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <5d6222a80710242016p27be8bcdk23421efb5990e14a@mail.gmail.com> <4720B383.40701@goop.org> <5d6222a80710250821x1da3fef1gabf4b776a7b33048@mail.gmail.com>
In-Reply-To: <5d6222a80710250821x1da3fef1gabf4b776a7b33048@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251955.09571.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 16:21, Glauber de Oliveira Costa wrote:
> > > is there any particular reason we're using -traditional in
> > > EXTRA_AFLAGS in Makefiles?
> >
> > What?  Where?  I thought I removed them all.  Or is this from the x86_64
> > tree?
> 
> This is from arch/x86/kernel/Makefile_64

Indeed. I, too, would like it to be removed, even only on the grounds
that whoever added it didn't add a small one-line comment explaining why.
--
vda
