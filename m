Return-Path: <linux-kernel-owner+w=401wt.eu-S965892AbXCFOnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965892AbXCFOnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 09:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965889AbXCFOnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 09:43:20 -0500
Received: from tentacle.s2s.msu.ru ([193.232.119.109]:35465 "EHLO
	tentacle.sectorb.msk.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965888AbXCFOnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 09:43:19 -0500
Date: Tue, 6 Mar 2007 17:43:16 +0300
From: "Vladimir B. Savkin" <master@sectorb.msk.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: netdev@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       David Miller <davem@davemloft.net>, hawk@diku.dk,
       harry@atmos.washington.edu, linux-kernel@vger.kernel.org,
       Rick Jones <rick.jones2@hp.com>
Subject: Re: Packet timestamps (was: Re: Network performance degradation from 2.6.11.12 to 2.6.16.20)
Message-ID: <20070306144315.GA9036@tentacle.sectorb.msk.ru>
References: <200609181850.22851.ak@suse.de> <4514147D.5040803@hp.com> <20070306132551.GB8412@tentacle.sectorb.msk.ru> <200703061538.45049.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200703061538.45049.dada1@cosmosbay.com>
X-Organization: Moscow State Univ., Institute of Mechanics
X-Operating-System: Linux 2.6.20.1
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 03:38:44PM +0100, Eric Dumazet wrote:
> 2) "accurate_timestamps" is misleading. 
> 	Should be "disable_timestamps" 

Not, if default is 1, as in my patch.

~
:wq
                                        With best regards, 
                                           Vladimir Savkin. 

