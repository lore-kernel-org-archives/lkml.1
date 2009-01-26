Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZAZRP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZAZRP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZAZRPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:15:49 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:24364 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751448AbZAZRPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:15:48 -0500
X-YMail-OSG: CLTEOvsVM1k6IUyzN5PZxmWpMxVTfg0yiY2PdT7Q1MF0l129tEgQx3Y5dnMRz6rHbeVF_1eN98co_ukoPWucrCYYuNH5Q1py_Bfc20fbjaYd1fVqGw_7mM7shM4FmxvGTNyKAxoA56LIF2UeI2818qc18SK.2LPkiE1kkzf0movwoiK5ga8xP8kBfzS.SCJYkPjrwnAm3NFQMyzXUj0wmS_L7nc-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: Spamming linux-kernel and linux-scsi by out-of-tree patches
	(LIO)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20090126081905.7c112170@infradead.org>
References: <497DB7D0.8000302@vlnb.net>
	 <1232984234.3248.18.camel@localhost.localdomain>
	 <497DDFF8.8070707@vlnb.net>  <20090126081905.7c112170@infradead.org>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 09:15:24 -0800
Message-Id: <1232990124.24642.156.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 08:19 -0800, Arjan van de Ven wrote:
> On Mon, 26 Jan 2009 19:08:24 +0300
> Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> 
> > I wouldn't object if Nicholas des the same and send in linux-scsi
> > and linux-kernel a complete patchset, which we will review and
> > discuss. But he sends *intermediate* patches and this looks for me
> > like a violation of fundamental rules/intention of Linux kernel
> > mailing lists, hence I complain.
> > 
> > So, should I understand your words that you agree if I also start 
> > sending intermediate patches for SCST to linux-scsi/linux-kernel?
> > 
> 
> 
> <looking in as an outsider>
> 
> I am thoroughly surprised by this email exchange.
> From where I sit, there is almost no such thing as posting patches too
> early. Really. Transparency and early review/feedaback is by far
> more important than ignoring a few more patches in an area you
> don't careabout.
> 

For those wanting to know more about "Release Early, Release Often":

http://www.catb.org/~esr/writings/cathedral-bazaar/cathedral-bazaar/ar01s04.html

<SNIP>

Linus's open development policy was the very opposite of
cathedral-building. Linux's Internet archives were burgeoning, multiple
distributions were being floated. And all of this was driven by an
unheard-of frequency of core system releases.

Linus was treating his users as co-developers in the most effective
possible way:

        7. Release early. Release often. And listen to your customers.
        

Linus's innovation wasn't so much in doing quick-turnaround releases
incorporating lots of user feedback (something like this had been
Unix-world tradition for a long time), but in scaling it up to a level
of intensity that matched the complexity of what he was developing. In
those early times (around 1991) it wasn't unknown for him to release a
new kernel more than once a day! Because he cultivated his base of
co-developers and leveraged the Internet for collaboration harder than
anyone else, this worked.

<SNIP>

--nab

