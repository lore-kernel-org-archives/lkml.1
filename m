Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbYAVKf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbYAVKf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbYAVKfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:35:17 -0500
Received: from ext-nj2ut-7.online-age.net ([64.14.54.237]:45380 "EHLO
	ext-nj2ut-7.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbYAVKfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:35:15 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 05:35:13 EST
Date: Tue, 22 Jan 2008 11:24:36 +0100
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080122102436.GA15563@wszip-kinigka.euro.med.ge.com>
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4793F775.6090403@davidnewall.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, 

on http://www.feise.com/~jfeise/Downloads/linux-abi/

a patch named  linux-abi-2.6.22.3_3.diff.bz2 can be found.

(and I know a friend of mine got it working OK - old
Informix 4GL medical app compiled for SCO ... :-)

Karl


On Mon 080121, David Newall wrote:
> Andi Kleen wrote:
> > You seem to be under the illusion that iBCS2 support works currently
> > in mainline and that only this patch would break it.
> I cannot imagine what brings you to that conclusion.  Suffice to say you
> are entirely and inexplicably wrong.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Karl Kiniger            mailto:karl.kiniger@med.ge.com
GE Medical Systems Kretztechnik GmbH & Co OHG
Tiefenbach 15           Tel: (++43) 7682-3800-710  Voip(GE): 1662 710
A-4871 Zipf Austria     Fax: (++43) 7682-3800-47 C: +43 6991 3800 710
