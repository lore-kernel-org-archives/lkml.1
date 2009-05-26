Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbZEZSXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbZEZSXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbZEZSXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:23:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:56181 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbZEZSXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ROYkXxGU9ovIj0kgXgcuz1dZv0601lZEapamV9g7JQXL2EAKp10xer8tYI1DlZjHzJ
         +EIHvajl1gO1bwVl3g3QP4PRjQXUBQjofwW8Okl2Fus9VLzgXOcOb2AuA3WEUSxkFg3b
         zKM9aTsHlYVtnoJCR5BenrcczfNOSY4KzQ5TE=
MIME-Version: 1.0
In-Reply-To: <s5h1vqb924p.wl%tiwai@suse.de>
References: <43e72e890905260153q59c76842ueb967459bc7353ee@mail.gmail.com> 
	<s5h1vqb924p.wl%tiwai@suse.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 May 2009 11:23:18 -0700
Message-ID: <43e72e890905261123q183baee9waa4c5299484b3cf1@mail.gmail.com>
Subject: Re: ALSA/sound compatibilty package for older kernels
To: Takashi Iwai <tiwai@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
       Hauke Mehrtens <hauke@hauke-m.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 10:59 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 26 May 2009 01:53:07 -0700,
> Luis R. Rodriguez wrote:
>>
>> In spirit with the compat-wireless-2.6 stable releases [1], here is an
>> initial attempt at compat-sound-2.6 [2] which allows you to compile
>> and install the latest ALSA/sound drivers on kernels >= 2.6.27.
>
> Well, the alsa-driver tarball can install the drivers on older
> kernels, even on 2.2 and 2.4 kernels :)
>
> The latest snapshot tarball is found at:
>    ftp://ftp.kernel.org/pub/linux/kernel/people/tiwai/snapshot/alsa-driver-snapshot.tar.gz

Oh nice :) I did not realize.

  Luis
