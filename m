Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbZATPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbZATPRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbZATPRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:17:11 -0500
Received: from iksaif.net ([88.191.73.63]:59545 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbZATPRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:17:10 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2009 10:17:10 EST
From: Corentin Chary <corentincj@iksaif.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH v2 1/3] eeepc-laptop: Add support for extended hotkeys
Date: Tue, 20 Jan 2009 16:08:31 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.28-gentoo; KDE/4.1.96; x86_64; ; )
Cc: lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, ecc@cmu.edu,
       linux acpi <linux-acpi@vger.kernel.org>
References: <a26244bd6e7cae264155edca7f3c22f8f319b239.1227194932.git.mjg@redhat.com> <71cd59b00812290312u282851eepb1ecc2666d6013ab@mail.gmail.com> <9b2b86520901180204q29802ec6kd6dceaa165e61555@mail.gmail.com>
In-Reply-To: <9b2b86520901180204q29802ec6kd6dceaa165e61555@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901201608.31634.corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009 11:04:01 Alan Jenkins wrote:
> On 12/29/08, Corentin Chary <corentin.chary@gmail.com> wrote:
> > On Sun, Dec 28, 2008 at 4:20 PM, Matthew Garrett <mjg59@srcf.ucam.org>
> >
> > wrote:
> >> Hi Len,
> >>
> >> Can these be merged for .29?
> >
> > Acked-by: Corentin Chary <corentincj@iksaif.net>
>
> They're not present in 2.6.29-rc2.  Have they just missed the boat?
>
> Thanks
> Alan

They are now in git://git.iksaif.net/acpi4asus.git acpi4asus and I'll re-send 
them soon to Len because this serie is a litle outdated now that the drivers
have been moved into drivers/platform/x86/ .

-- 
--
Corentin Chary
http://xf.iksaif.net
