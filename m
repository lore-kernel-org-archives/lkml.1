Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbZBDNhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbZBDNhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZBDNhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:37:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:63035 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZBDNhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:37:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r/i4SyDcQABZ2RCOJqZcjMH+hT1LHfdCcUJ+gzyUyZcQLb+lMCTbTETX5ECzecvgux
         3YBMGwXV7v17Wptt2FJrXKSgczpGDuj6Z8rZnep0JpnX2PXonIJzpoZcBlz6EEul8CEB
         mDFSzP5+GGkMfGF1SdeBzZrfMiHEC1UHNK/Qk=
MIME-Version: 1.0
In-Reply-To: <CGyEB0S4BpO.A.YyD.n6YiJB@chimera>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
	 <CGyEB0S4BpO.A.YyD.n6YiJB@chimera>
Date: Wed, 4 Feb 2009 08:37:17 -0500
Message-ID: <a44ae5cd0902040537i2b3e074asd13d30eec68e9749@mail.gmail.com>
Subject: Re: [Bug #12159] 2.6.28-rc6-git1 -- No sound produced from Intel HDA 
	ALSA driver
From: Miles Lane <miles.lane@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug is fixed in Linus' tree, afaict.

On Wed, Feb 4, 2009 at 5:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12159
> Subject         : 2.6.28-rc6-git1 -- No sound produced from Intel HDA ALSA driver
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2008-11-27 20:33 (70 days old)
> References      : http://marc.info/?l=linux-kernel&m=122781805620212&w=4
> Handled-By      : Takashi Iwai <tiwai@suse.de>
>
>
>
