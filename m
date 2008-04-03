Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYDCLKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYDCLKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 07:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYDCLKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 07:10:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:27974 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYDCLKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RacjWkfEc9aEWpNgrmYkTBPWd7WrVncGX7fotKVu+jkvn8avdi4FttxdlCTI1bqwAUr3rYecqMZHA3iD2iWedYqW5g8d+I7ddvyzhQcgBnow4+whIrHWsz8qvDiXKJQZ2eDJ7oSd3eESntF9BzQyt8gW55plj+l57ay3gkCG+6A=
Message-ID: <544ab8580804030410r5f2b90ffpfcde9e7d2ed3860e@mail.gmail.com>
Date: Thu, 3 Apr 2008 13:10:06 +0200
From: "=?ISO-8859-1?Q?K=E1roly_Kasza?=" <kaszak@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: w35und: cleanup wbusb.c a bit
Cc: "kernel list" <linux-kernel@vger.kernel.org>, lcostantino@gmail.com,
       someone@dunanet.hu
In-Reply-To: <20080403000321.GA5013@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403000321.GA5013@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I comitted your wbusb.c clean ups as rev15. Thank you!
Also still planning to rewrite the driver (based on Softmac maybe),
your help will be appreciated if we ever get there :)

On Thu, Apr 3, 2008 at 2:03 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>  List winbond in wireless/Makefile, and some cleanups for wbusb.c
>
>  Signed-off-by: Pavel Machek <pavel@suse.cz>
>
