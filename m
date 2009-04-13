Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZDMQNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZDMQNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZDMQNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:13:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51989 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZDMQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FlsUPaBFIYORTHq3QNypOInUxKn4rn0ZQ3WX5cRYNrgDloAjrTlkMp85ZGuNtevdjv
         RT3vqNJGPfXgUPzESmKjS1ItQS1drRZLXRHFtq1CwxErDwpsNwg+tXyTSX46XQ102c92
         GNqD2gGeb3B+0x0R8XwghIbLiN5m8cp+3yBbU=
Date: Mon, 13 Apr 2009 20:13:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       heukelum@fastmail.fm
Subject: Re: [PATCH] Fix warnings after: x86: apic - introduce imcr_ helpers
Message-ID: <20090413161333.GA7763@lenovo>
References: <20090413153924.GA20287@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413153924.GA20287@mailshack.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Mon, Apr 13, 2009 at 05:39:24PM +0200]
| Impact: fix compiler warnings
| 
| The patch "introduce imcr_ helpers" introduced good comments, but
| also a few compile warnings. This fixes it.
|     
| Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
| Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
| 
| ---
| 
| Hi Ingo,
| 
| Cyrill forgot to refresh the patches :).

The patch, not patches :) I've just updated it
but then poped without refresh (doh!).

| 
| Greetings,
|     Alexander
| 
...

Thanks a lot, Alexander! Ingo, apply it please.

       Cyrill
