Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbYHEQjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbYHEQjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbYHEQjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:39:11 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:25268 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753185AbYHEQjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:39:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5dJAxl8yjDZiQsPkaUw+5pb2t57bGk7f/k40SjMiXE9p4VDFrYgbz4GEzhRDNPd4m3t56k5ksej4K/8gmToY2plKpnVhZHpjNUvXFDKO1LV06sHSnC1h7v36EgxMtyPNvj4W+z0InuQPKuCk9sCBnv10nwPg1JaVf72f0YlIL1Y=  ;
X-YMail-OSG: J7ziFk4VM1l27oNm0zYT3526qfPjjNehMB11xa4cBNkSoHU6Y00pP3zXoYHBJSbcVLsgq.eTUflzTmfJZDUyHqLmNBYEGlbk8rxgeACcVg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: jmerkey@wolfmountaingroup.com
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Date: Wed, 6 Aug 2008 02:38:55 +1000
User-Agent: KMail/1.9.5
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060145.22321.nickpiggin@yahoo.com.au> <56575.166.70.238.45.1217950327.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <56575.166.70.238.45.1217950327.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808060238.56113.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 01:32, jmerkey@wolfmountaingroup.com wrote:
> > On Wednesday 06 August 2008 01:19, jmerkey@wolfmountaingroup.com wrote:

> > That would be great if you do work on kgdb... But I guess I do miss
> > the point, then. Is there a technical difference with kgdb that cannot
> > be worked around, a difference of opinion with maintainers, a wish to
> > have mdb features at short notice?
>
> Nick, its OK.  There have been 27,453 downloads of the patches from my ftp
> server since yesterday when I osted it -- from what I am seeing people are
> voting with their feet.   People can get it and I even posted it t
> SourceForge as well.  After ten years of working on Linux I thougt it
> would be nice for something I wrote to end up there.  It will happen when
> its time.  As it stands, people are using it and it is going to help a lot
> of folks, which is what this is all about.
>
> :-)

That's all well and good :). But it didn't exactly answer my question.
My question was not what is the point of you writing these patches, but
what is the point of merging it into the kernel (over the alternatives).
It may seem like a trivial question, but it is one that must be answered
in order to be considered to get merged.
