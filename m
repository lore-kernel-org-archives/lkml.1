Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbXGJQvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbXGJQvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXGJQvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:51:46 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37020
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751687AbXGJQvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:51:45 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Lf_kernel_messages] Re: Documentation of kernel messages (Summary)
Date: Tue, 10 Jul 2007 12:50:54 -0400
User-Agent: KMail/1.9.6
Cc: holzheu@linux.vnet.ibm.com, randy.dunlap@oracle.com, jack@suse.cz,
       kenistoj@us.ibm.com, heiko.carstens@de.ibm.com, pavel@ucw.cz,
       hpa@zytor.com, jengelh@computergmbh.de, sam@ravnborg.org,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       lf_kernel_messages@linux-foundation.org, tim.bird@am.sony.com,
       arjan@infradead.org, auke-jan.h.kok@intel.com, Valdis.Kletnieks@vt.edu,
       gregkh@suse.de, linux-kernel@vger.kernel.org, joe@perches.com,
       Andrew Morton <akpm@linux-foundation.org>, hansendc@us.ibm.com,
       davem@davemloft.net
References: <1181747217.29512.9.camel@localhost.localdomain> <200706251144.48658.rob@landley.net> <20070709181007.GA2343@thunk.org>
In-Reply-To: <20070709181007.GA2343@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101250.55494.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007 14:10:07 Theodore Tso wrote:
> The idea that was tossed about was essentially printk hashes (hashed
> on message plus filename, with optional reporting of filename+line
> number), with the messaging catalog being maintained externally.  Yes,
> that will be a major pain for whoever wants to do the translation ---
> but it puts the onus on the people who would be getting the value for
> this to do the work.

Sounds good to me.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
