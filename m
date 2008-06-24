Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYFXSvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYFXSvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYFXSv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:51:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:58474 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbYFXSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:51:26 -0400
Subject: Re: merge conflicts with tip/master
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Bernhard Walle <bwalle@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080624203807.232a414a@kopernikus.site>
References: <1214327937.27577.6.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080624203807.232a414a@kopernikus.site>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 24 Jun 2008 11:51:05 -0700
Message-Id: <1214333465.27577.30.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 11:38 -0700, Bernhard Walle wrote:
> * Alok Kataria <akataria@vmware.com> [2008-06-24 10:18]:
> >
> > While working with tip/master...after following the steps in the readme
> > @ http://people.redhat.com/mingo/tip.git/readme.txt
> >
> > I usually do any changes and manage them using "quilt".
> > Once the changes are pushed upstream, i do a "quilt pop"
> > and generally try a "git pull" to check for any new changes, along with
> > the change that was just pushed.
> 
> You might also try guilt [1], which is a mix between st-git and quilt.

Thanks Bernhard, 
I will have a look.

> Just a hint, it does not solve your problem. :)
> 

Ingo's steps helped resolve the problem though.

--
Alok

> 
> Bernhard
> 
> [1] http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/
> 
> --
> Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development

