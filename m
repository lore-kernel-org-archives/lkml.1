Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbYFQODF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbYFQODF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757662AbYFQOCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:02:54 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:24732 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbYFQOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:02:53 -0400
Message-ID: <90eb1dc70806170702j5390c89bh44d27aa2aa8cd821@mail.gmail.com>
Date: Tue, 17 Jun 2008 09:02:52 -0500
From: "Javier Guerra" <javier@guerrag.com>
To: "Martin Michlmayr" <tbm@cyrius.com>
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
Cc: "Anthony Liguori" <anthony@codemonkey.ws>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080617134452.GA4836@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616150550.GA16086@deprecation.cyrius.com>
	 <48568503.90607@codemonkey.ws>
	 <20080617123918.GA2397@deprecation.cyrius.com>
	 <4857B92F.9020309@codemonkey.ws>
	 <20080617133234.GE2397@deprecation.cyrius.com>
	 <20080617134452.GA4836@deprecation.cyrius.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 8:44 AM, Martin Michlmayr <tbm@cyrius.com> wrote:
> Sorry, Anthony, I just realized I misparsed your response.  So you're
> saying that it's a known issue and that VMware is the problem.  Thanks
> a lot!  I'll take it up with VMware.

i think what he's saying is that VMWare is a closed binary blob
executing in the kernel; so there's no way to certify anything with
this.

as soon as you put some unknown (and unknowable, unverifiable,
untrustable) code in the kernel, you can't know what will work and
what won't.

-- 
Javier
