Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbXEXUhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbXEXUhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXEXUgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:36:50 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:5232 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbXEXUgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s14HdNiLpmgfdPewg14RPvTXxxwvhBZzzNvdifRaLntGCfHs0+B63Zm0niQgGKBNXec7g6iDVDjvd5dVXIGxFlgJ7tcnmkWrjKa8aRHIp+0maHYf1D/0+RgYxyg+x+fO1tOJh1LpmRdEZrSCZW0A9QM272a/n/i7irsA8NbkyFo=
Message-ID: <7fddb68d0705241336q3d8462eavb22992b5f04a3c80@mail.gmail.com>
Date: Thu, 24 May 2007 22:36:46 +0200
From: "Amaury De Ganseman" <amaury.deganseman@gmail.com>
To: "Dave Jones" <davej@redhat.com>,
       "Amaury De Ganseman" <amaury.deganseman@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.2 and vfat
In-Reply-To: <20070524200754.GB29049@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7fddb68d0705240053n54a96606u238a37e3a265b23c@mail.gmail.com>
	 <20070524165307.GB23169@redhat.com>
	 <7fddb68d0705241256n11843438o1b8e2fc5c2ee3c99@mail.gmail.com>
	 <20070524200754.GB29049@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry now it's ok...
I've do an mkfs.vfat and it's good now.

Sorry for this "stupid" post ;-)

On 5/24/07, Dave Jones <davej@redhat.com> wrote:
> On Thu, May 24, 2007 at 09:56:04PM +0200, Amaury De Ganseman wrote:
>  > It's the same with sdc1
>
> exactly the same error ? (the dmesg only listed the sdc errors)
> what does fdisk -l /dev/sdc look like ?
> does fsck.vfat /dev/sda1 find any errors?
>
>         Dave
>
> --
> http://www.codemonkey.org.uk
>
