Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbXFJU3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbXFJU3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXFJU3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:29:20 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:37834 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751024AbXFJU3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:29:19 -0400
X-YMail-OSG: eAjTGOYVM1mfrCh1lpIAI2qC.Chp5vjAyjr3daR0cUVeotynLgY1ncLhT46WuwBxv4ohM9PvRg--
X-RocketYMMF: rancidfat
Date: Sun, 10 Jun 2007 13:04:51 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
To: david@lang.hm, Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706100201540.6675@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <700465.32295.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- david@lang.hm wrote:


> > Yes, and in the process, AA stores compiled regular expressions in
> > kernel. Ouch. I'll take "each file it's own label" over _that_ any time.
> 
> and if each file has it's own label you are going to need regex or similar 
> to deal with them as well.

Now that you're going to have to explain. Nothing like that 
on any of the MLS systems I'm familiar with, and I think that
I know just about all of them.


Casey Schaufler
casey@schaufler-ca.com
