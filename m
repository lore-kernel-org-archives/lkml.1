Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbXCPJ0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbXCPJ0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbXCPJ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:26:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:35923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697AbXCPJ0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:26:08 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: CIJOML <cijoml@volny.cz>
Subject: Re: kernel OOPSes when changing DVB-T adapter in 2.6.21-rc3
Date: Fri, 16 Mar 2007 10:25:44 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
References: <200703091641.54249.cijoml@volny.cz> <200703151502.32161.oneukum@suse.de> <200703161013.37312.cijoml@volny.cz>
In-Reply-To: <200703161013.37312.cijoml@volny.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703161025.44681.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 16. März 2007 10:13 schrieb CIJOML:
> Hi,
> 
> looks like more general problem with 2.6.21-rc3. This happens when I remove my 
> PCMCIA USB2.0/IEEE1384 adapter from slot:

Yes, the more important it is to know whether -rc2 works.
And please report this as a generic sysfs failure to lkml.

	Regards
		Oliver
