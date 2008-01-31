Return-Path: <linux-kernel-owner+w=401wt.eu-S934638AbYAaRpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638AbYAaRpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762904AbYAaRpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:45:31 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:42059 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757826AbYAaRp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:45:29 -0500
X-YMail-OSG: sm.reUoVM1lwFH9E8sCclcBffRW0XUdV2Z681nODSdX0grVfSjYMbC5cwsewjFDLJoX3byDZWQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 31 Jan 2008 09:45:26 -0800
From: Chris Wedgwood <cw@f00f.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] kill hotplug init/exit section annotations
Message-ID: <20080131174526.GA2488@puku.stupidest.org>
References: <1201726817.3292.84.camel@localhost.localdomain> <20080130212011.GA26621@uranus.ravnborg.org> <1201729295.3292.94.camel@localhost.localdomain> <20080130223219.GT29368@does.not.exist> <20080131074436.GA31966@uranus.ravnborg.org> <1201795051.3131.13.camel@localhost.localdomain> <20080131081120.27505dc0@laptopd505.fenrus.org> <20080131162141.GC19700@cs181133002.pp.htv.fi> <20080131090749.72781689@laptopd505.fenrus.org> <20080131171436.GG19700@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131171436.GG19700@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 07:14:36PM +0200, Adrian Bunk wrote:

> > cpuhotplug is required for suspend/resume.
>
> Not on UP computers.

those are less and less common now, most modern laptops are dual core
