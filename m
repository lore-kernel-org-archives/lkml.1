Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbYKLANb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbYKLANb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYKLANX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:13:23 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:28368 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYKLANW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:13:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=EQGb6FkmtQApZXLey+gQH20G6YiUcg1yZEWK0o+cOGvv9qotgUPcLrtrDSE3niwBwr
         FRFcxkfV7hfxkPWPgLi3mdaqiv8Wr+9voBbk+/abSpgQ/AfkGyGbWyowRSFLnnVPRqUa
         40P8y9UDMZcHEXaOwUOYHDmAsyJ4PXS0rW/8w=
Date: Tue, 11 Nov 2008 18:13:16 -0600
From: "J. K. Cliburn" <jcliburn@gmail.com>
To: David Madore <david.madore@ens.fr>
Cc: Linux Kernel Mailing-List <linux-kernel@vger.kernel.org>,
       Linux NetDev Mailing-List <netdev@vger.kernel.org>,
       atl1-devel@lists.sourceforge.net
Subject: Re: atl1e Ethernet driver not seeing packets sent to
 33:33:00:00:00:01 multicast
Message-ID: <20081111181316.36e819fa@osprey.hogchain.net>
In-Reply-To: <20081111220015.GA18215@clipper.ens.fr>
References: <20081111133108.GA7124@clipper.ens.fr>
	<20081111080611.7f6d4371@osprey.hogchain.net>
	<20081111155908.GA14665@clipper.ens.fr>
	<20081111100816.58a7cf09@osprey.hogchain.net>
	<20081111220015.GA18215@clipper.ens.fr>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 23:00:15 +0100
David Madore <david.madore@ens.fr> wrote:

> On Tue, Nov 11, 2008 at 10:08:16AM -0600, J. K. Cliburn wrote:
> > Can you please try this patch?
[...]
> Now it works.  Many thanks!

Thank you very much for reporting the bug and testing the fix.

Jay
