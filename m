Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZCZHzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZCZHzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZCZHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:55:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58464 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZCZHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:55:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49CB3356.4070104@s5r6.in-berlin.de>
Date: Thu, 26 Mar 2009 08:48:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090323 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "J.H." <warthog19@eaglescrag.net>, users@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, support@osuosl.org,
       Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Martin Bligh <mbligh@mbligh.org>, "Jorge O. Castro" <jorge@ubuntu.com>,
       bugme-admin@linux-foundation.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Jim Zemlin <jzemlin@linux-foundation.org>
Subject: Re: [kernel.org users] [KORG] Bugzilla Upgrade / Server move
References: <49C9D99D.2050400@eaglescrag.net> <49CB2D84.3070206@kernel.org>
In-Reply-To: <49CB2D84.3070206@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Is there anyway to put the comment input area at the bottom of the
> page?  Trying to reply at the top just messes up my head in weird
> ways.

Here is a patch:
https://bugzilla.redhat.com/show_bug.cgi?id=457022#c19
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
