Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbXJBIMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbXJBIMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXJBIMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:12:08 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:65276 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbXJBIMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:12:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cp2mL0mraIItwiUW7QJ+qw2s2ENcWX30IZisxv34mo+GOBTYwGval9q8VuRsej9RWJAEaTmOjSyJHlkb/k9kwEtJq1w6/gDVAq4a1YoGID0GTH241jGbXJP6wtZEZV64q8k9s4F3M2KM/eOzoU6D+hvc8DbRHYrDfIuO8HxKBX0=
Message-ID: <9a8748490710020112m3e4014daid2c4ae6ddf439fdb@mail.gmail.com>
Date: Tue, 2 Oct 2007 10:12:05 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: - eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch removed from -mm tree
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <47015E76.6080601@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709290551.l8T5ppNg002621@imap1.linux-foundation.org>
	 <47015E76.6080601@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2007, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
...
>
> is this actually a problem? everybody should be running e100. I'm surprised to see
> a patch for eepro100, just before it gets removed...
>
The patch is actually about a year old, it just never got merged. And
IMHO, as long as the driver is in the tree it makes sense to apply
fixes to it.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
