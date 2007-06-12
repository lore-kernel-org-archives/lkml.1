Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbXFLRZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbXFLRZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbXFLRY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:24:57 -0400
Received: from gate.in-addr.de ([212.8.193.158]:37775 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753396AbXFLRYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:24:55 -0400
X-Greylist: delayed 1271 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2007 13:24:55 EDT
Date: Tue, 12 Jun 2007 19:03:11 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Pavel Machek <pavel@ucw.cz>, david@lang.hm
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070612170311.GA13854@marowsky-bree.de>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm> <20070610083427.GA24808@elf.ucw.cz> <Pine.LNX.4.64.0706100201540.6675@asgard.lang.hm> <20070610210547.GC25138@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070610210547.GC25138@elf.ucw.cz>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-10T23:05:47, Pavel Machek <pavel@ucw.cz> wrote:

> But you have that regex in _user_ space, in a place where policy
> is loaded into kernel.
> 
> AA has regex parser in _kernel_ space, which is very wrong.

That regex parser only applies user defined policy. The logical
connection between your two points doesn't exist.


Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

