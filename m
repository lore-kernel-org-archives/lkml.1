Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZFDK0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZFDK0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZFDK02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:26:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:41457 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZFDK01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kfaBc1ApInF5rkgdtp4dIZrFKrnIvUJCmIdzGXW7kWGLwEkKa8lbPpDRYeszZHhcoz
         abm8WopwdZfuI64EFvfHX6tddaEE41rhpQYtg1RC/90Ykaxq509NFdrC4CHf/PQopuXz
         Xje8huQYFwimb29MaVUcvtafpBvKvwGPXWYJ4=
MIME-Version: 1.0
In-Reply-To: <18973.54100.522638.314377@samba.org>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	 <87bpqbaji9.fsf@devron.myhome.or.jp>
	 <18940.9039.850580.48730@samba.org>
	 <87ab5v9381.fsf@devron.myhome.or.jp>
	 <18940.10942.989329.993465@samba.org>
	 <87ocub7ngh.fsf@devron.myhome.or.jp>
	 <18940.12667.429391.927727@samba.org>
	 <8763gj7m23.fsf@devron.myhome.or.jp>
	 <ce9ab5790905270505i530febcerfda874f5049c6c93@mail.gmail.com>
	 <18973.54100.522638.314377@samba.org>
Date: Thu, 4 Jun 2009 15:56:28 +0530
Message-ID: <ce9ab5790906040326t8deb5fbs600c8c8cd93d9746@mail.gmail.com>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
From: vimal singh <vimal.newwork@gmail.com>
To: tridge@samba.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 5:27 AM,  <tridge@samba.org> wrote:
> Hi Vimal,
>
>  > Any conclusion has been reached reagarding this patch...?
>
> We've been working to resolve some of the issues people raised (for
> example, a public explanation on why the patch is needed). We have
> also been working towards an improved version of the patch. Sorry it's
> taking so long, but we hope to be able to post a new patch soon.
Is there any problem in previous patch, which you looking to fix in
the new version? Or these are all non-technical issues.
Can I take this patch for as of now?

-vimal

>
> Cheers, Tridge
>



-- 
---
Regards,
\/ | |\/| /-\ |_

____      __o
------   -\<,
-----  ( )/ ( )
