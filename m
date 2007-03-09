Return-Path: <linux-kernel-owner+w=401wt.eu-S2993093AbXCIKcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993093AbXCIKcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767143AbXCIKcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:32:00 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:42649 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993093AbXCIKb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:31:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KquplCocNCecMCNLsKG/SsZekdLUkY1Y0etCpK51uvKBr6iPrT51TVePfGyvVucxMPWsi5YRPvFbEJvAK8fX9dMFbOOAJKSAvTMBfLykQcXixItbALu65TxPo4OABiTYhH5V8j6/c0w1wi9xZsTMFiUNblsVgnQ9Gte57ZFxRyY=
Message-ID: <45F1379C.9090609@gmail.com>
Date: Fri, 09 Mar 2007 19:31:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: OOPS with 2.6.21rc2-git (ata: conflict with ide0/1)
References: <45EC9A67.8070204@intel.com> <45EFC3D1.208@gmail.com> <45EFDEF6.7000909@garzik.org>
In-Reply-To: <45EFDEF6.7000909@garzik.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Which patch?
> 
> Since this affects libata directly, and since devres came in via libata,
> I would rather that libata bugs not get /too/ blocked by patches in
> other trees.

This one.

  http://article.gmane.org/gmane.linux.kernel/495515

-- 
tejun
