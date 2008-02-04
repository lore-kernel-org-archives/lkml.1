Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYBDN4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYBDN4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYBDN4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:56:33 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37310 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbYBDN4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:56:32 -0500
Date: Mon, 4 Feb 2008 15:56:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lee Revell <rlrevell@joe-job.com>, Chris Friesen <cfriesen@nortel.com>,
       Giridhar Pemmasani <pgiri@yahoo.com>, Pavel Roskin <proski@gnu.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080204135632.GA27206@cs181133002.pp.htv.fi>
References: <20080129225701.GS8767@does.not.exist> <754585.89171.qm@web32403.mail.mud.yahoo.com> <20080130175447.GB29368@does.not.exist> <47A0C138.2070807@nortel.com> <20080130185446.GF29368@does.not.exist> <75b66ecd0801301136n193fa44bg890ad4dab9b61eb5@mail.gmail.com> <20080204124208.1b32fc04@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080204124208.1b32fc04@core>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 12:42:08PM +0000, Alan Cox wrote:
> On Wed, 30 Jan 2008 14:36:19 -0500
> "Lee Revell" <rlrevell@joe-job.com> wrote:
> 
> > On Jan 30, 2008 1:54 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > > IANAL, and I would therefore ask a lawyer whether, and if yes under
> > > which circumstances, shipping a binary driver written for another OS
> > > dynamically linked into the Linux kernel would not be a criminal offense.
> > >
> > 
> > Please stop throwing around words like "criminal".  If this is in fact
> > illegal it would be a civil matter.
> 
> Actually in large parts of europe multiple repeated infractions of
> copyright law are criminal matters.

"multiple repeated infractions" might not be required.

I remember one case in Germany where offering 272 songs in a P2P network 
once resulted in a fine based on criminal law. [1]

Convictions under civil law seem to be easier and result in higher costs 
for the copyright violators, so the music industry tends to use the 
reportings of offences in Germany only for getting the names of the 
people from the IP addresses they have (happened in a five digit number 
of cases), don't care about whether the criminal law cases proceed, and 
focus on the civil law cases.

But if you are doing more than just filesharing, or even make a profit 
out of it, the maximum penalties go up to 5 years in jail...

> Alan

cu
Adrian

[1] http://www.jurpc.de/rechtspr/20040236.pdf

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

