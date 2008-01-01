Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYAAX5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYAAX5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYAAX5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:57:17 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51947 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbYAAX5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:57:16 -0500
Date: Wed, 2 Jan 2008 01:57:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled 'time' option removal
Message-ID: <20080101235701.GJ27566@does.not.exist>
References: <20080101134656.GG2360@does.not.exist> <Pine.LNX.4.64.0801011852250.14900@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801011852250.14900@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 06:53:54PM +0100, Jan Engelhardt wrote:
> 
> On Jan 1 2008 15:46, Adrian Bunk wrote:
> >index 20c4c8b..93aac19 100644
> >--- a/Documentation/feature-removal-schedule.txt
> >+++ b/Documentation/feature-removal-schedule.txt
> >@@ -233,10 +233,2 @@ Who:	Jean Delvare <khali@linux-fr.org>
> > ---------------------------
> >-
> >-What:	'time' kernel boot parameter
> >-When:	January 2008
> >-Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
> >-	enabled or disabled as needed
> >-Who:	Randy Dunlap <randy.dunlap@oracle.com>
> >-
> 
> I am sure the people who added themselves in the Who: line would have
> taken care of this soon enough, I mean, it's just 19 hours into the
> first day :-)

If Randy decides he wants to submit his own patch for this that wouldn't 
be a problem for me.  :-)

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

