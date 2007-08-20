Return-Path: <linux-kernel-owner+w=401wt.eu-S1760827AbXHTQYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbXHTQYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbXHTQXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:23:52 -0400
Received: from web90408.mail.mud.yahoo.com ([216.252.100.160]:22126 "HELO
	web90408.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759415AbXHTQXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:23:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=XyoJnMQOKl9PS6xWT5ILGCe9XO8+QN6JJFKzfrot6J1AklrxIPU5qEtTO2XcefGXDJz3xzX2y+qTNHo26GzAXDVsNr0zuk7KKbBhLwboaIyyiwNgZa9LCEZIA0vPKTLRXOek8E6DCvdmLyMiFnEEjmNFdlJUrFXEH3rrz8CSLic=;
X-YMail-OSG: Qod7E.sVM1nUfTiaXpA.UHmAOhSyjVF9QAtKlOwDACTo.eLl4X1S3ggqjQdlNf1Dgg--
Date: Mon, 20 Aug 2007 09:23:46 -0700 (PDT)
From: James Corey <ploversegg@yahoo.com>
Subject: Re: 2.6.23-rc3 and SKY2 driver issue
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
In-Reply-To: <20070820090227.6ceb2934@freepuppy.rosehill.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <624025.57129.qm@web90408.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Hemminger
<shemminger@linux-foundation.org> wrote:

> On Mon, 20 Aug 2007 08:42:21 -0700 (PDT)
> James Corey <ploversegg@yahoo.com> wrote:
> 
> > 
> > --- Stephen Hemminger
> > <shemminger@linux-foundation.org> wrote:
> > 
> > > On Thu, 16 Aug 2007 10:25:45 +0200
> > > "Michal Piotrowski"
> >
> > > Please reproduce with a more recent kernel?
> > 
> > Um, I thought 2.6.23rc WAS pretty recent. :-)
> > 
> > I'll check if there is something newer in the
> > repository now.
> > 
> 
> What is the chip version?  Please send console log:
> "dmesg | grep sky2"
> 
> 
> -- 
> Stephen Hemminger <shemminger@linux-foundation.org>
> 


Ah ... details.

Machine: 

Dell Optiplex 745

Kernel:

2.6.23-rc3 #1 SMP Tue Aug 14 19:44:07 EDT 2007 x86_64
x86_64 x86_64 GNU/Linux

Card:

D-Link DGE-550SX

# dmesg | grep sky2
sky2 0000:04:00.0: v1.16 addr 0xdf9fc000 irq 16
Yukon-XL (0xb3) rev 3
sky2 eth1: addr 00:17:9a:73:87:60
sky2 eth1: enabling interface
sky2 eth1: ram buffer 96K
sky2 eth1: Link is up at 1000 Mbps, full duplex, flow
control none




       
____________________________________________________________________________________
Be a better Globetrotter. Get better travel answers from someone who knows. Yahoo! Answers - Check it out.
http://answers.yahoo.com/dir/?link=list&sid=396545469
