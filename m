Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbXFPSYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbXFPSYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 14:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXFPSXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 14:23:52 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:25215 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXFPSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 14:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rHM0E1KNYDa8yD4CqWPNwNSXtlS8MrYIzfpaf888d4Ga7JeXdY0sxT21e0Spr8TubYsJNbLwSngME9VrvXNdtXwmn/T03lwH0h7/G1/ksaatIey4lLIGqKDvJHkXePi7cxwAoj/O+LfdDuHKYJaHaW3RqH9dlE2rmr/6EWQ2YfY=
Date: Sat, 16 Jun 2007 22:22:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Chris Friesen <cfriesen@nortel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       apw@shadowen.org, jschopp@austin.ibm.com
Subject: Re: coding style
Message-ID: <20070616182207.GA8485@cvg>
References: <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <4672D4D3.60905@intel.com> <20070615182255.GB8151@cvg> <4673E09F.704@s5r6.in-berlin.de> <20070616143101.GA6579@cvg> <46742130.6010409@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46742130.6010409@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Stefan Richter - Sat, Jun 16, 2007 at 07:43:12PM +0200]
| From: Stefan Richter <stefanr@s5r6.in-berlin.de>
| To: gorcunov@gmail.com
| CC: "Kok, Auke" <auke-jan.h.kok@intel.com>,
| 	Chris Friesen <cfriesen@nortel.com>,
| 	LKML <linux-kernel@vger.kernel.org>,
| 	Randy Dunlap <randy.dunlap@oracle.com>,
| 	Jan Engelhardt <jengelh@computergmbh.de>,
| 	dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
| 	apw@shadowen.org, jschopp@austin.ibm.com
| Subject: Re: coding style
| Date: Sat, 16 Jun 2007 19:43:12 +0200
| 
| gorcunov@gmail.com wrote:
| > [Stefan Richter - Sat, Jun 16, 2007 at 03:07:43PM +0200]
| > | Cyrill Gorcunov wrote:
| > | > There sould be someting making strict rule over alignment (as it done
| > | > for the tabs size).
| > | 
| > | That's impracticable.  Alignment, as it serves readability, cannot be
| > | covered by a few strict rules.
| 
| > Yes, but C syntax (and grammar) is limited set. And alignmet I'm talking
| > about may cover the following statements only:
| > 
| > 1) Mathematical
| > 2) Logical
| > 3) Function's arguments
| 
| Sure, but we have sometimes long names and long ./-> dereference
| expressions.  Alignment of those after line wraps sometimes turns out
| better if 'taste' rather than a simple rule is applied.
| -- 
| Stefan Richter
| -=====-=-=== -==- =----
| http://arcgraph.de/sr/
| 

Of course you're absoulutely right!!! And that is why I've mentoined
that it would be _recommendations_ only in CodingStyle.

		Cyrill

