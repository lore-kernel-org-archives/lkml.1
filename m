Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZEJVlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZEJVlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZEJVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:41:11 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38370 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbZEJVlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=r5y1gLCB+5TnUeTDXtOe+yeRPl4Ni9ICoc/ly3/euVdmHCg8WhEPkcGN+p66Vt5Atp
         pwGMFCXPqcsSNaYTbgVIwoVzNrPC3Y/uH4p3JF2E7G3971OVXBOAzGbXkF35svjVH3e3
         9xS4oLF3OojpesF72hd39b8Vpl1ROS26SZNUw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: RFC: MAINTAINER email address style?
Date: Sun, 10 May 2009 23:45:27 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com,
       torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
References: <20090407081312.GH1408@ucw.cz> <1241989210.6711.5.camel@Joe-AcerAspire> <20090510210918.GA22742@uranus.ravnborg.org>
In-Reply-To: <20090510210918.GA22742@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905102345.28297.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 May 2009 23:09:18 Sam Ravnborg wrote:
> On Sun, May 10, 2009 at 02:00:10PM -0700, Joe Perches wrote:
> > On Sun, 2009-05-10 at 22:53 +0200, Sam Ravnborg wrote:
> > > On Sun, May 10, 2009 at 01:26:40PM -0700, Joe Perches wrote:
> > > > Should names and email addresses in MAINTAINERS be integrated?
> > > > Should it stay as-is or be changed to:
> > > > 
> > > > M: name <email>
> > > > M: name2 <email2>
> > > 
> > > I strongly prefer this style. It fits the way I do
> > > copy'n'paste of selected email addresses.
> > > 
> > > If I want to add Rafael in a Cc: line I have to
> > > anually add "" to surround his name due to the "J." and I
> > > have to manually add <>.
> > > Typing in his email address is a no no - and I can spell
> > > to Wysovski correct only a few times a day.
> > 
> > Exceeded your quota today already? ;)
> > 
> 
> I prefer this style: 
> > M:	Len Brown <len.brown@intel.com>
> > M:	Pavel Machek <pavel@ucw.cz>
> > M:	"Rafael J. Wysocki" <rjw@sisk.pl>

Seconded.
