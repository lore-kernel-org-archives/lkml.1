Return-Path: <linux-kernel-owner+w=401wt.eu-S1946455AbXBCPbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946455AbXBCPbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946463AbXBCPbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:31:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:35082 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946455AbXBCPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:31:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=neUSpDHELSC9HiRAL/eoY4ulxHgu9DVC3ul3KqtIWuTDwA8dtMp8gFomm2A8XGGvZjfM3D+B0c015bZiGg1y+FHLhqiNIzG5EXC7QRRIRJf7YDo3P+5kiPpcclKGWnzc3pohtgRo0oicFha1qEeGN58kzdKpE4k3dH9mg0/Dqnc=
Message-ID: <58cb370e0702030731i61b32e93j3f7a8f0e061cb136@mail.gmail.com>
Date: Sat, 3 Feb 2007 16:31:41 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2] Char: add __devinitdata to pci_device_ids
Cc: "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Cyclades team" <async@cyclades.com>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, nils@kernelconcepts.de, wim@iguana.be,
       R.E.Wolff@bitwizard.nl, "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <2106930977152662464@wsc.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2106930977152662464@wsc.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> add __devinitdata to pci_device_ids
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

http://lkml.org/lkml/2003/8/1/135

I think that it is still true, Greg?

Bart
