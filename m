Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbXFOTbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbXFOTbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXFOTbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:31:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:58060 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbXFOTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:31:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fcM7bWK6KLZ9hWjXyhZsTztasdApwQvYme/sr/+DcY7Bi6tpII06YXdNmYF1QbZj6e8+gThH46Dks2x72FCvQQs5XkKCZ/FCna7hpqWzywKNBNxGjCu7eeq7Ej7/9iZxSfRe+UtgkdfoBWzUAfdgY0S+HLIzR2reXeALUs0kJ7s=
Date: Fri, 15 Jun 2007 23:29:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
Message-ID: <20070615192936.GD8151@cvg>
References: <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <20070615110326.b0762b7a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr> <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4672E6B3.1080205@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Kok, Auke - Fri, Jun 15, 2007 at 12:21:23PM -0700]
| Cyrill Gorcunov wrote:
| >[Jan Engelhardt - Fri, Jun 15, 2007 at 09:10:49PM +0200]
| >| 
| >| On Jun 15 2007 11:03, Randy Dunlap wrote:
| >| >> 
| >| >> "use tabs for indents and spaces for alignment"
| >| >> 
| >| >> If that means you need to use two dozen spaces, then so be it.
| >| >
| >| >I don't think that's what that rule means, but I didn't write it,
| >| >so I'm not absolutely sure about it.
| >| >
| >| >but we know that tab stops are every 8th character, not 4 :)
| >| 
| >| Hardly.
| >| 
| >| 
| >| 
| >| 
| >| 	Jan
| >| -- 
| >| 
| >
| >Jan, as I see from CodingStyle:
| >
| >	"Tabs are 8 characters, and thus indentations are also 8 characters."
| >
| >Actually it would be perfect to get strict rules also for math. and log.
| >operators being splitted on several lines:
| 
| this doesn't say anything about alignment, which was his point :)
| 
| Auke
| 

Yep... ;)

		Cyrill

