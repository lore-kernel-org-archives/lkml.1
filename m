Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbZLJN1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbZLJN1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759814AbZLJN1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:27:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45121 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503AbZLJN1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:27:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=cBpon2aioQCQo9p8qhkXASPN4gZ6kxKmKGtuwT5M0lFamB/c9pGlWidT1kbAyC3d9t
         qkDdubuvEgyY+HOzzMclfVlFotNE2Chh+HOifIpwtnmP0x56WWxsmlUoF6fwbC/ROpHd
         28ceYXRo/Hrni4kDS5I4rG7XPKgoVH8rSlEtM=
Date: Thu, 10 Dec 2009 15:27:44 +0200
From: Dan Carpenter <error27@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Jes Sorensen <jes.sorensen@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Toshiba Bluetooth enabler (v2) (was: Re: [PATCH] Toshiba
	Bluetooth enabler (rfkill))
Message-ID: <20091210132744.GB25664@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Alan Jenkins <sourcejedi.lkml@googlemail.com>,
	Jes Sorensen <jes.sorensen@gmail.com>, linux-acpi@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>
References: <4B192D08.9080608@gmail.com> <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com> <4B1E85A9.3030005@gmail.com> <9b2b86520912090517l458bc21cobbb138d460e11f53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520912090517l458bc21cobbb138d460e11f53@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 01:17:48PM +0000, Alan Jenkins wrote:
> On 12/8/09, Jes Sorensen <jes.sorensen@gmail.com> wrote:
> > On 12/08/2009 11:05 AM, Alan Jenkins wrote:
> >> Cool.  This must be the shortest ACPI driver :-).
> >
> > Hi Alan,
> >
> > Here's an updated version that addresses most of your comments.
> 
> Hi again
> 
> >> Try to send patches inline if possible, it makes them easier to review.
> >
> > Not possible with Thunderbug, sorry.
> 
> I'm guessing you mean Thunderbird.  I manage in Thunderbird by
> 
> a) composing in HTML
> b) selecting "preformat" from the drop-down menu (the default is "body text"
> c) copy+pasting the patch
> 
> I seem to have word wrap disabled as well (under
> prefs->composition->general), but I think "Preformat" is enough on its
> own.
> 

There is a Thunderbird section under Documentation/email-clients.txt

regards,
dan carpenter

