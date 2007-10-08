Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbXJHBAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbXJHBAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 21:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbXJHBAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 21:00:22 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:23485 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbXJHBAV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 21:00:21 -0400
X-Greylist: delayed 1746 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Oct 2007 21:00:21 EDT
Date: Mon, 8 Oct 2007 01:29:17 +0100
From: Ken Moffat <ken@linuxfromscratch.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Oleg Verych <olecom@flower.upol.cz>,
       Rene Herman <rene.herman@keyaccess.nl>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: syntax highlighting, emacs ([PATCH 0/2] Colored kernel output (run2))
Message-ID: <20071008002917.GB28926@deepthought>
References: <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu> <Pine.LNX.4.64.0710072123460.16301@fbirervta.pbzchgretzou.qr> <47093AFB.8000805@keyaccess.nl> <Pine.LNX.4.64.0710072203570.16301@fbirervta.pbzchgretzou.qr> <20071007205024.GT22435@flower.upol.cz> <Pine.LNX.4.64.0710072238050.16301@fbirervta.pbzchgretzou.qr> <20071007221829.GU22435@flower.upol.cz> <Pine.LNX.4.64.0710080005370.16301@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710080005370.16301@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 12:11:21AM +0200, Jan Engelhardt wrote:
> 
> Actually, blue is perceived as one of the darkest colors by the human
> eye. There is a reason that the RGB -> grayscale transformation uses
> the following weighting: r=76 g=154 b=26.

 But, not every video card reproduces blue in the same way, let
alone every monitor - somewhere I've got an old CRT monitor where
blue text was mostly unreadable (_too_dark_).  For photo-editing,
I now use xgamma to get adequately-consistent results on whichever of
4 machines I'm using (one LCD monitor, with KVM switch) - the
settings for the individual machines are very different.

 And, of course, people have different colour vision (and unless we
are labelled as colour-blind, we each regard our colour vision as
"normal").  So, what is perfectly acceptable for you on specific
hardware may be totally unusable for someone else.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
