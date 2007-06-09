Return-Path: <linux-kernel-owner+w=401wt.eu-S1762381AbXFIIL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762381AbXFIIL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759980AbXFIILm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:11:42 -0400
Received: from bay0-omc2-s35.bay0.hotmail.com ([65.54.246.171]:55885 "EHLO
	bay0-omc2-s35.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761966AbXFIILj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:11:39 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Sat, 9 Jun 2007 04:10:45 -0400
From: Sean <seanlkml@sympatico.ca>
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
Message-Id: <20070609041045.f3b7a7ec.seanlkml@sympatico.ca>
In-Reply-To: <Pine.LNX.4.64.0706090104210.6675@asgard.lang.hm>
References: <20070514110607.549397248@suse.de>
	<200706042303.28785.agruen@suse.de>
	<1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
	<20070609014644.9ed4fa29.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706090004290.6675@asgard.lang.hm>
	<20070609033601.640e83a1.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706090104210.6675@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 08:11:54.0921 (UTC) FILETIME=[D7A1C990:01C7AA6D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 01:06:09 -0700 (PDT)
david@lang.hm wrote:


> but the SELinux API's are not the core security API's in Linux, the LSM 
> API's are. and AA is useing the LSM API's (extending them where they and 
> SELinux don't do what's needed)
> 

Calling LSM "core" and pretending that SELinux can't do 90% of what you
want doesn't change the facts on the ground.  Clinging to the current AA
implementation instead of honestly considering reasonable alternatives
does not inspire confidence or teamwork.

Sean.
