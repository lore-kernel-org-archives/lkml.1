Return-Path: <linux-kernel-owner+w=401wt.eu-S1760391AbZAGR7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391AbZAGR7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbZAGR71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:59:27 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:35767 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756432AbZAGR70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:59:26 -0500
Subject: Re: mmotm 2009-01-07-00-23 uploaded
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4964EA9C.1000204@oracle.com>
References: <200901070828.n078SRKJ024599@imap1.linux-foundation.org>
	 <4964BEB0.7040400@gmail.com>  <4964EA9C.1000204@oracle.com>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Wed, 07 Jan 2009 10:59:19 -0700
Message-Id: <1231351159.3470.458.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 09:47 -0800, Randy Dunlap wrote:
> Jiri Slaby wrote:
> > On 01/07/2009 09:28 AM, akpm@linux-foundation.org wrote:
> >> The mm-of-the-moment snapshot 2009-01-07-00-23 has been uploaded to
> > 
> > Hi,
> > 
> > there is wrong parenthesis pairing added in:
> > patches/mm-add-proc-controls-for-pdflush-threads-fix.patch
> > which causes a build error.
> 
> (lots of those)
> 
> adding cc: to Peter M.
> 
> 

This is Andrew's 'cleanup' patch to my series.  

Best,
-PWM

