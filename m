Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbYEANhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbYEANhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYEANh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:37:27 -0400
Received: from brmea-mail-2.Sun.COM ([192.18.98.43]:65333 "EHLO
	brmea-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbYEANh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:37:26 -0400
Date: Thu, 01 May 2008 09:35:04 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: A system for rebootless kernel security updates
In-reply-to: <20080501113802.GC28005@nibiru.local>
To: weigelt@metux.de
Cc: linux kernel list <linux-kernel@vger.kernel.org>
Reply-to: davecb@sun.com
Message-id: <4819C708.1000802@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu>
 <87r6cvgyi1.fsf@basil.nowhere.org>
 <alpine.DEB.1.10.0804280119001.9237@vinegar-pot.mit.edu>
 <4815A721.1040101@firstfloor.org>
 <alpine.DEB.1.10.0804281907150.28653@vinegar-pot.mit.edu>
 <20080501113802.GC28005@nibiru.local>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enrico Weigelt wrote:
> I didn't have the time for an deeper study yet, but as you already
> mentioned, there're lots of limitations which can make it harmful:
> as soon as interfaces chance, you're in *big* trouble. There should
> be a way for finding them (automatically). Maybe extract the 
> interface signatures (including structs!) so some appropriate place
> next to the kernel, so they can be checked before (re)loading the
> module.

  Actually there is a mature discipline around data changes that
dates back to before Unix v7, but it's off-topic for this
discussion: it would make the changes too big (;-))

  If anyone is interested, see http://multicians.org/stachour.html
and/or send me mail

--dave (reading LKML when he should be working) c-b
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
