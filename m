Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbXFPRnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbXFPRnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 13:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXFPRnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 13:43:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54571 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXFPRnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 13:43:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46742130.6010409@s5r6.in-berlin.de>
Date: Sat, 16 Jun 2007 19:43:12 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: gorcunov@gmail.com
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Chris Friesen <cfriesen@nortel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       apw@shadowen.org, jschopp@austin.ibm.com
Subject: Re: coding style
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <4672D4D3.60905@intel.com> <20070615182255.GB8151@cvg> <4673E09F.704@s5r6.in-berlin.de> <20070616143101.GA6579@cvg>
In-Reply-To: <20070616143101.GA6579@cvg>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

gorcunov@gmail.com wrote:
> [Stefan Richter - Sat, Jun 16, 2007 at 03:07:43PM +0200]
> | Cyrill Gorcunov wrote:
> | > There sould be someting making strict rule over alignment (as it done
> | > for the tabs size).
> | 
> | That's impracticable.  Alignment, as it serves readability, cannot be
> | covered by a few strict rules.

> Yes, but C syntax (and grammar) is limited set. And alignmet I'm talking
> about may cover the following statements only:
> 
> 1) Mathematical
> 2) Logical
> 3) Function's arguments

Sure, but we have sometimes long names and long ./-> dereference
expressions.  Alignment of those after line wraps sometimes turns out
better if 'taste' rather than a simple rule is applied.
-- 
Stefan Richter
-=====-=-=== -==- =----
http://arcgraph.de/sr/
