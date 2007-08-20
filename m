Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbXHTHoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbXHTHoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 03:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXHTHoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 03:44:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:47611 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXHTHoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 03:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bQLbjpV0Y+GlzfZdX6FcvfpLZ6QSDzcLehsl9xaK4FXiSpyaKHm79Bu7GXW1F4RBr8zBe3KwOGVMHyICK4hpWVnGZs2gWED3tcbvxQc/p9CrFbLYZEyryhjcYihQkYByB9tX9f2ybWXWWIYPwiqGYI7iol+dItYsbRgSx2/+nTU=
Message-ID: <ef8c225f0708200044x7e20d225r9e4700f6925a67b8@mail.gmail.com>
Date: Mon, 20 Aug 2007 13:14:10 +0530
From: "Andev Debi" <andev.debi@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: How to send a break? - dump from frozen 64bit linux
Cc: "=?ISO-8859-1?Q?Haar_J=E1nos?=" <djani22@netcenter.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490605282137g24c4eb7awb475318bad7e63b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <01b701c6818d$4bcd37b0$1800a8c0@dcccs>
	 <20060527234350.GA13881@voodoo.jdc.home>
	 <004501c68225$00add170$1800a8c0@dcccs>
	 <9a8748490605280917l73f5751cmf40674fc22726c43@mail.gmail.com>
	 <01d801c6827c$fba04ca0$1800a8c0@dcccs>
	 <9a8748490605282137g24c4eb7awb475318bad7e63b1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/06, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 28/05/06, Haar János <djani22@netcenter.hu> wrote:
> [snip]
> > I can only use swap _file_ in this config, and swapping into file is
> > relatively slow.
>
> Not so. With a 2.4.x kernel swap files were slower than swap
> partitions, but with the 2.6 kernel a swap file is just as fast as a
> swap partition.
>

what made this possible? any pointers please?
