Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbXCVTzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbXCVTzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934210AbXCVTzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:55:04 -0400
Received: from nijmegen.renzel.net ([195.243.213.130]:35172 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934212AbXCVTzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:55:01 -0400
From: Mws <mws@twisted-brains.org>
To: linux-kernel@vger.kernel.org
Subject: Re: MCE Erros
Date: Thu, 22 Mar 2007 20:54:43 +0100
User-Agent: KMail/1.9.6
Cc: Thomas Glanzmann <thomas@glanzmann.de>
References: <20070322195043.GA19732@cip.informatik.uni-erlangen.de>
In-Reply-To: <20070322195043.GA19732@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703222054.45426.mws@twisted-brains.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007, Thomas Glanzmann wrote:
> Hello,
> I have two Dual Opteron Machines where I get two MCE errors on. The
> first one is:
> 
>         MCE 0
>         HARDWARE ERROR. This is *NOT* a software problem!
>         Please contact your hardware vendor
>         CPU 0 4 northbridge TSC edc587de6e99
>         ADDR 1001a0000
>           Northbridge GART error
>                bit61 = error uncorrected
>           TLB error 'generic transaction, level generic'
>         STATUS a40000000005001b MCGSTATUS 0
> 
> I see this error exactly 8 times. What does 'GART' mean?

Graphics Address Remapping Table

used with agp

regards
marcel


