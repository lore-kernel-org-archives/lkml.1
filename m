Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZKEVQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZKEVQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 16:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbZKEVQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 16:16:38 -0500
Received: from web50103.mail.re2.yahoo.com ([206.190.38.31]:25913 "HELO
	web50103.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758850AbZKEVQh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 16:16:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=EL2PksGrt8Y3GVVQeTV7ZPomCDDZTPdTS4oIyC3l9cMFu8xViDbp+gfNG92iTgY2T2R1n8MUFFqC6s3cOo3rovpLpL8uoTbm4QubgdYkEGGdAhRKsWWyewHuOWZWqLjV8E4POf41QmFzX7Q+LsO2uodxa0FRl+g7AW+f2vWqNYk=;
Message-ID: <975697.46031.qm@web50103.mail.re2.yahoo.com>
X-YMail-OSG: YXe4SXYVM1loD0aJJcgot3B.NgL2YExpnMyYk2LPhLGx32cqhFG8Sy6n53fVRPlMJMC9TL5zORU0vADhqxgV44n1G1T0iMLHRU2JupVM5chLtoN2x5.3wWAjV38VjiReB7j9cTot_yr_abMVmBh2sGC5UOAY2JGlfTwB3Mex5p.rMF4sndLXtJqBWvW_07_UhDTZwp7RrQ9QE2WKNby2G90AT35SHW6ufxDQSr.BWsSsgXeJs8_rKY83zK4HTlCe06QQDYtNBSvkgY320Y42uZu1_bUHZ5DK5Ma3h0TMjPCjBuvJ4nLszrIEIKaQW0Zem8xUWbMcHdLda4yOuuwC.XMC8Lo3Medn7pWeRPNOjtdsUTqIaK8UJ8e2NVGOqDR1jRfv_tAkb_.U6T.9LmAVlX4osCb89nnaPJ0cRC_FCnIxH_y2HE5zQkrjyHAsrjbCT0iD0zh_6FQhmxbuuQt_MQCTF4OOWh3N1NN3yUeNUKSAe_CTIPABns6wdmOjzbM-
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.7.361.4
Date: Thu, 5 Nov 2009 13:16:41 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] Documentation/edac
To: Davidlohr Bueso <dave@gnu.org>, Jiri Kosina <jkosina@suse.cz>
Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LSU.2.00.0911051616530.9988@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 11/5/09, Jiri Kosina <jkosina@suse.cz> wrote:

> From: Jiri Kosina <jkosina@suse.cz>
> Subject: Re: [PATCH] Documentation/edac
> To: "Davidlohr Bueso" <dave@gnu.org>
> Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org
> Date: Thursday, November 5, 2009, 8:18 AM
> On Wed, 4 Nov 2009, Davidlohr Bueso
> wrote:
> 
> > ---
> >  Documentation/edac.txt |    7 +++----
> >  1 files changed, 3 insertions(+), 4
> deletions(-)
> > 
> > diff --git a/Documentation/edac.txt
> b/Documentation/edac.txt
> > index 06f8f46..79c5332 100644
> > --- a/Documentation/edac.txt
> > +++ b/Documentation/edac.txt
> > @@ -80,7 +80,7 @@ is:
> >  
> >      broken_parity_status
> >  
> > -as is located in
> /sys/devices/pci<XXX>/0000:XX:YY.Z directorys for
> > +as is located in
> /sys/devices/pci<XXX>/0000:XX:YY.Z directories for
> >  PCI devices.
> >  
> >  FUTURE HARDWARE SCANNING
> > @@ -288,9 +288,8 @@ Total UE count that had no
> information attribute fileY:
> >  
> >      'ue_noinfo_count'
> >  
> > -    This attribute file displays the
> number of UEs that
> > -    have occurred have occurred
> with  no informations as to which DIMM
> > -    slot is having errors.
> > +    This attribute file displays the
> number of UEs that have occurred
> > +    with no information as to which
> DIMM slot is having errors.
> >  
> 
> Applied, thanks.

So I assume that you are pushing this upstream and I don't have to?

thx

doug t

> 
> -- 
> Jiri Kosina
> SUSE Labs, Novell Inc.
> 
