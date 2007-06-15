Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbXFOSZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbXFOSZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXFOSY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:24:56 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:3251 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbXFOSYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=I67BFXCNjnMDcV0KNp2w8LxggZPAlF5Sj1S6bF4gH9UyzavqUaZH/+OcMnzm6r/V9ZXauMKyw+xrWaiLNKGPZF8c3477whosV3+NPt8FkkWjmCJonQMI6TBYGd605hGPyElIHDTHCj6KYp3Rix7EOm/0w4NufhU2+GK3QfxPX6A=
Date: Fri, 15 Jun 2007 22:22:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Chris Friesen <cfriesen@nortel.com>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       apw@shadowen.org, jschopp@austin.ibm.com
Subject: Re: coding style
Message-ID: <20070615182255.GB8151@cvg>
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <4672D4D3.60905@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4672D4D3.60905@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Kok, Auke - Fri, Jun 15, 2007 at 11:05:07AM -0700]
| Chris Friesen wrote:
| >Consider two people, one with tabs as 8 characters and one with tabs as 
| >4 characters.  If person A aligns using a tab plus a space (giving 9 
| >characters), then the alignmnet will be all screwed up for person B (who 
| >will see 5 characters of alignment).
| >
| >The only rule that works (setting aside bad tools) is:
| >
| >"use tabs for indents and spaces for alignment"
| >
| >If that means you need to use two dozen spaces, then so be it.
| 
| it would be awesome if the checkpatch.pl script could distinguish between 
| indentation and alignment space usage - this is going to cause major 
| confusion with patch submitters.
| 
| I personally think that the sentence
| 
|   "use tabs for indents and spaces for alignment"

Absoulutely agreed with you! There sould be someting making strict rule
over alignment (as it done for the tabs size).

| 
| should also be in the CodingStyle document to avoid confusion.
| 
| Auke
| 

		Cyrill

