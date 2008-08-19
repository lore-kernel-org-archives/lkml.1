Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYHSNz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYHSNz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYHSNzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:55:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:50147 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYHSNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ne9x1l6nCMy3SVzs7LUFviCl/M9RTERA03c1Pyj3Epe5PjzR4h02rb8STgf5usEIR5
         cQR7A++DvutVgOM8hHz04j0SqOkYN1/v+VtiJfQm0JyU0ykDeqLMP7mur9UlAR+4BjwM
         LBXtLRKPW6ZVBykB5otzkMs3jwP6zrY7ku0pY=
Message-ID: <ac9c93b10808190655o76d2a452i740aaf87aafa685@mail.gmail.com>
Date: Tue, 19 Aug 2008 15:55:15 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: hppfs; CONFIG_HPPFS; used ?? or orphaned??
Cc: linux-kernel@vger.kernel.org, jdike@karaya.com, viro@zeniv.linux.org.uk
In-Reply-To: <20080819134517.GB8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac9c93b10808190638q16fb54d6uef68548b7e5fd526@mail.gmail.com>
	 <20080819134517.GB8852@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/19 Adrian Bunk <bunk@kernel.org>:
> On Tue, Aug 19, 2008 at 03:38:37PM +0200, Frans Meulenbroeks wrote:

> $ grep -r HPPFS *
> arch/um/Kconfig:config HPPFS

Aargh. How could I have forgotten my old friend grep -r.
Thanks for enlightning me & apologies for the disturbance!

FM.
