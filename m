Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbXIZVuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbXIZVuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbXIZVuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:50:05 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:39023 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXIZVuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:50:04 -0400
Message-ID: <46FAD408.3040500@ens-lyon.org>
Date: Wed, 26 Sep 2007 23:50:00 +0200
From: Brice Goglin <Brice.Goglin@ens-lyon.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jeff Garzik <jeff@garzik.org>, torvalds@osdl.org,
       Andrew Morton <akpm@osdl.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: State of the Linux PCI Subsystem for 2.6.23-rc8
References: <20070926210010.GC1734@kroah.com> <46FAD1EA.6090504@ens-lyon.org> <20070926213931.GA24049@suse.de>
In-Reply-To: <20070926213931.GA24049@suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Sep 26, 2007 at 11:40:58PM +0200, Brice Goglin wrote:
>   
>> Greg KH wrote:
>>     
>>> Here's a summary of the current state of the Linux PCI subsystem, as of
>>> 2.6.23-rc8.
>>>
>>> If the information in here is incorrect, or anyone knows of any
>>> outstanding issues not listed here, please let me know.
>>>
>>> List of outstanding regressions from 2.6.22:
>>> 	- none known.
>>>
>>> List of outstanding regressions from older kernel versions:
>>> 	- none known.
>>>   
>>>       
>> What about http://marc.info/?l=linux-pci&m=119072400008538&w=2 ?
>>     
>
> That's not a regression, right?  Tt's probably never worked for that
> kind of box :)
>   

Ok, fair enough, I can't be sure it ever worked :)

> I think the pci bus patches that are pending from Jeff Garzik should fix
> up these issues.  They are in one of his trees, and in the -mm release,
> if you are able to test those.
>   

Ok, I'll see what I can do.

Jeff, could you point me to some good candidate patches for fixing this?

Brice

