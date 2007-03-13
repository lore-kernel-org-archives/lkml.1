Return-Path: <linux-kernel-owner+w=401wt.eu-S933338AbXCMQRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbXCMQRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933534AbXCMQRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:17:15 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:54507 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338AbXCMQRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:17:13 -0400
X-Greylist: delayed 1245 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 12:17:13 EDT
Date: Tue, 13 Mar 2007 16:56:24 +0100
From: =?iso-8859-2?Q?Tom=E1=B9_Janou=B9ek?= <tomi@nomi.cz>
To: thomas@m3y3r.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [5/6] 2.6.21-rc3: known regressions
Message-ID: <20070313155624.GA31105@nomi.cz>
References: <1173801099.45f6c88bef4c4@213.133.104.17>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1173801099.45f6c88bef4c4@213.133.104.17>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 13, 2007 at 04:51:39PM +0100, thomas@m3y3r.de wrote:
> Can you please try to compile without nohz and without hrtimers and try it
> again?

A colleage told me to try this yesterday and if I remember correctly, it did
not help. I may try it again because I'm not sure whether it wasn't some other
issue thing did not work, but I'm absolutely sure that no matter what these
settings are, the machine does not resume or hangs soon after resume (in the
case of s2disk). And this is since 2.6.20. 2.6.21 just added the 'wait until
keypress'.

Regards,
-- 
Tomá¹ Janou¹ek, a.k.a. Liskni_si, http://work.lisk.in/
