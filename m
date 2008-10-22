Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYJVWRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYJVWRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYJVWRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:17:47 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:34230 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963AbYJVWRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:17:46 -0400
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
	set.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081022231500.4172bba3@lxorguk.ukuu.org.uk>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org>	<1224607284.6161.22.camel@alok-dev1>
	 <20081021174008.GH12825@one.firstfloor.org>
	 <1224612294.6161.43.camel@alok-dev1>
	 <20081021181536.GI12825@one.firstfloor.org>
	 <1224616236.6161.60.camel@alok-dev1>
	 <20081021192746.GJ12825@one.firstfloor.org>
	 <1224703427.13953.8.camel@alok-dev1>
	 <20081022195845.GP12825@one.firstfloor.org>
	 <1224712846.13953.37.camel@alok-dev1>
	 <20081022231500.4172bba3@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 22 Oct 2008 15:17:45 -0700
Message-Id: <1224713865.13953.48.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 15:15 -0700, Alan Cox wrote:
> On Wed, 22 Oct 2008 15:00:46 -0700
> Alok Kataria <akataria@vmware.com> wrote:
> 
> > [dropped LKML of the cc list]
> 
> Sorry this discussion belongs on the LKML list. Please take it back to
> the list.

It was never dropped, sorry for the confusion :-)

