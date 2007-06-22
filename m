Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbXFVSMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbXFVSMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbXFVSM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:12:28 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:37424
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734AbXFVSM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:12:27 -0400
Date: Fri, 22 Jun 2007 11:12:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: James Morris <jmorris@namei.org>
cc: Chris Mason <chris.mason@oracle.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Lars Marowsky-Bree <lmb@suse.de>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <Line.LNX.4.64.0706221012340.6190@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706221109520.14942@asgard.lang.hm>
References: <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz>
 <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
 <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
 <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
 <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain>
 <20070622140240.GM6222@think.oraclecorp.com> <Line.LNX.4.64.0706221012340.6190@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, James Morris wrote:

> On Fri, 22 Jun 2007, Chris Mason wrote:
>
>> But, this is a completely different discussion than if AA is
>> solving problems in the wild for its intended audience, or if the code
>> is somehow flawed and breaking other parts of the kernel.
>
> Is its intended audience aware of its limitiations?  Lars has just
> acknowledged that it does not implement mandatory access control, for one.
>
> Until people understand these issues, they certainly need to be addressed
> in the context of upstream merge.

there are always going to be people who misunderstand things. by this 
logic nothing can ever be merged that can be misused.

at least some of the intended audience (including me) do understand the 
limits and still consider the result useful.

David Lang
