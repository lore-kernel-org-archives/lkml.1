Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbXHUT2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbXHUT2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbXHUT2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:28:09 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:31415 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbXHUT2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kADgktu8lWOKBdacCI3FlYCbtVABN55SwVCEkDu7ycsht9UPP8i8nvF1QpPWFMmpT6M6bD8MdEIRWT3D1t5K03+olsttpYi30Cnmqb6yGfABn3EomOAKP24HW/AlW1guaDe3zFFoK0iS2zW5+8yxJnfqy3LYVdfAFu22/zC1Ido=
Message-ID: <5dc6fd9e0708211228u433dbe04n7ca69e8b78ae29d@mail.gmail.com>
Date: Tue, 21 Aug 2007 12:28:06 -0700
From: "Hex Star" <hexstar@gmail.com>
To: "=?ISO-8859-1?Q?Ismail_D=F6nmez?=" <ismail@pardus.org.tr>,
       linux-kernel@vger.kernel.org
Subject: Re: Trouble booting with new 2.6.22.3 kernel
In-Reply-To: <200708212225.51987.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com>
	 <200708212225.51987.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Ismail Dönmez <ismail@pardus.org.tr> wrote:

>
> Make sure your IDE/SATA driver is compiled in unless you are using an
> initramfs image.
>
> Regards,
> ismail
>
> --
> Perfect is the enemy of good
>

Ah so the IDE/SATA driver should not be a module (if it is a module
it'll cause this issue)?
