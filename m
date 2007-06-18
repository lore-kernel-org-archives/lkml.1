Return-Path: <linux-kernel-owner+w=401wt.eu-S933107AbXFRVv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbXFRVv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764320AbXFRVvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:51:14 -0400
Received: from animx.eu.org ([216.98.75.249]:44466 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763740AbXFRVvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:51:13 -0400
Date: Mon, 18 Jun 2007 17:46:33 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: david@lang.hm
Cc: Brendan Conoboy <blc@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
Message-ID: <20070618214633.GA15468@animx.eu.org>
Mail-Followup-To: david@lang.hm, Brendan Conoboy <blc@redhat.com>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
References: <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm> <20070618183324.GL10006@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm> <4676D8DE.3050903@redhat.com> <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Mon, 18 Jun 2007, Brendan Conoboy wrote:
> 
> >david@lang.hm wrote:
> >> yes, sorry, ultra 320 wide.
> >
> >Exactly how many channels and drives?
> 
> one channel, 2 OS drives plus the 45 drives in the array.

Given that the drives only have 4 ID bits, how can you have 47 drives on 1
cable?  You'd need a minimum of 3 channels for 47 drives.  Do you have some
sort of external box that holds X number of drives and only uses a single
ID?

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
