Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZATAZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZATAZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762909AbZATAWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:22:19 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:44980 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765556AbZATAWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:22:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CGSXfkjthmHI/j6uKBixVLfayVdgIf+TEie6sxac45tt24xXR+1eLPqDjKKPLc2p18
         ANW1Y2WQn+9c+zS8YSU3Mpx8QV0obLhyNdppld5B6NvJ2R9tQIyPOsx9DU4PCJkn8l7k
         rviJOgljWYc/ooLzujwUQkwJdWNKEWcyWiWMg=
Message-ID: <72dbd3150901191622k6b57cfd1pf7e156f5a80144f4@mail.gmail.com>
Date: Mon, 19 Jan 2009 16:22:17 -0800
From: "David Rees" <drees76@gmail.com>
To: "Diego Calleja" <diegocg@gmail.com>
Subject: Re: Faulty seagate drives, are going to be blacklisted?
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20090120002923.065f24ca@diego-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090120002923.065f24ca@diego-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 3:29 PM, Diego Calleja <diegocg@gmail.com> wrote:
> So, apparently there're a lot of drives on the market (including mine)
> that can die any day. Are those drives going to be blacklisted? It's
> still not clear if the firmware update is safe (some affected but
> working drives are dying after the firmware update), so some people
> like me is still waiting (and hoping that the drive doesn't die) for
> more stable firmware updates...

What would blacklisting these buggy drives achieve?  There isn't
anything that can be done except warn the user that they have known
buggy firmware and let them know they should contact the vendor for a
firmware update.  But until that bug hits, it doesn't seem to
otherwise affect the performance or functionality of the drives.

-Dave
