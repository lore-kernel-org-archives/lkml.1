Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZAJJX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZAJJX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 04:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZAJJXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 04:23:07 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:43339 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZAJJXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 04:23:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GMyVSTTmBVIUd+ErRHCMePThX0UnMlkWOPgdWlZLyUivJ45wkd0gQtu3XOLv8rH9Pw
         OzrKY1smEvYe2RzcG03OR25hJdfnkqaqhAICzOBxARP8WgG4933Vzm4u0Fz8n4IUfA42
         rVKWHxKatiKxTwdF6RhlUr9DmnIMqANahcqRw=
Date: Sat, 10 Jan 2009 12:22:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC 4/4] net: ppp_generic - introduce net-namespace
	functionality
Message-ID: <20090110092258.GA7622@localhost>
References: <20090109195154.320495476@gmail.com>> <4967accd.0305560a.3553.ffffd187@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4967accd.0305560a.3553.ffffd187@mx.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Fri, Jan 09, 2009 at 10:51:58PM +0300]
| - Each namespace contain ppp channels and units separately
|   with appropriate locks
| 
| CC: Paul Mackerras <paulus@samba.org>
| Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
...

Please ignore this one -- I forgot to update
ppp_init while was porting the patch. Will
fix.

		- Cyrill -
