Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYHHIlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYHHIlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYHHIkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:40:52 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:47094 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753401AbYHHIkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:40:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XPgTHyRjDFUc9Bhy6ubYPatetGKsa+Hv1rkfVh2VK0xejOEAsRJaSuvip8dD9fjHvVNqDEFRytWcI57DUUJi8n2aZt6FrzUfbLQ6oxFH9Yx4gNRGT++Z0NeSNVMNkiutWfcUg4MBOcbajf6f8IcrBCAXvSyrbRxh3aY1ZaLZv2s=  ;
X-YMail-OSG: X7qLgO4VM1knzz09cByzcXquiMv4mDpvrf9rNcSl.6izzpZRpwchnkaf9HnvzpkM39_ADFXfRIqs9elBL24g8CmziWP8pVzHftQFCCCDNCgka8Q87IvWye6iRQHoLAVoaYc6WYapre1r3r1X8uOYOQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Date: Fri, 8 Aug 2008 18:40:42 +1000
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808061550.22996.nickpiggin@yahoo.com.au> <489B34BA.4060300@linux-foundation.org>
In-Reply-To: <489B34BA.4060300@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081840.42646.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008 03:45, Christoph Lameter wrote:
> Nick Piggin wrote:
> > OK thanks for the info. I don't actually know debugger code as I
> > said, so I wasn't against merging mdb if it offers things that
> > kgdb fundamentally cannot.
> >
> > If so, then ensuring clean interfaces indeed would seem like a
> > good first step to getting it merged.
>
> The competing implementation is kdb not kgdb. kgdb is just a stub for
> remote debugging using gdb. kdb is an in-kernel debugger like the one
> proposed here.

Yes, so Andi said a couple of days ago ;)
