Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbYCaKKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbYCaKKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYCaKKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:10:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:1399 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbYCaKKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:10:09 -0400
X-SBRS: 3.6
X-MesageID: 48140151
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,581,1199682000"; 
   d="scan'208";a="48140151"
Date: Mon, 31 Mar 2008 10:44:40 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
Message-ID: <20080331094440.GA4406@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <20080308022321.GC5853@implementation> <20080323.215641.192753003.davem@davemloft.net> <20080324104330.GF4434@implementation.uk.xensource.com> <87abko734d.fsf@basil.nowhere.org> <20080324121719.GJ4434@implementation.uk.xensource.com> <20080324122700.GK4434@implementation.uk.xensource.com> <517f3f820803302100sdd50d71m4a990993f45e746c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <517f3f820803302100sdd50d71m4a990993f45e746c@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk, le Mon 31 Mar 2008 06:00:50 +0200, a écrit :
> My understanding about abstract namespace sockets (what Samuel calls
> unnamed sockets)

No, unnamed sockets are not in the abstract namespace sockets.  They
really have _no_ name.

Samuel
