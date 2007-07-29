Return-Path: <linux-kernel-owner+w=401wt.eu-S934986AbXG2T6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934986AbXG2T6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933371AbXG2T6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:58:42 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:3677 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763211AbXG2T6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FX8OWBpNB7Lqxffw2XCldQDlx2wpXfaPbVBZgS2wj+p0ky3yNQwZe5hlG4CCm+QC08h6XJzebugAxlow6EvX7+kMOf0SxMMgqvF77fPYThsD0KEMVCARg4o253Rhz48gxlEBL8enrDXJRp7mseN067MNFC0W8ia5li40w4yGIII=
Message-ID: <5ebbd9b50707291258l1d67fa20g3542dd3bbfcb4aef@mail.gmail.com>
Date: Sun, 29 Jul 2007 19:58:39 +0000
From: "Frank Hale" <frankhale@gmail.com>
To: "Cal Peake" <cp@absolutedigital.net>
Subject: Re: ACPI on Averatec 2370
Cc: "Gabriel C" <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com
In-Reply-To: <5ebbd9b50707291158n4cfffcbl7f620bd10181fb6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
	 <46ACD8DB.2020108@googlemail.com>
	 <Pine.LNX.4.64.0707291428100.7379@lancer.cnet.absolutedigital.net>
	 <5ebbd9b50707291158n4cfffcbl7f620bd10181fb6d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Your work around seems to do the trick. I took out SMP support, added
ACPI and now it boots normally.

On 7/29/07, Frank Hale <frankhale@gmail.com> wrote:
> > Frank, can you try a non-SMP build with ACPI and see if you still have the
> > problem?
>
> I certainly will, I never tried it without it so now I am curious.
> Thanks a bunch!
>
