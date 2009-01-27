Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZA0Iqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZA0Iqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZA0Iqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:46:39 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:2333 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZA0Iqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:46:39 -0500
Date: Tue, 27 Jan 2009 09:46:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [2.6.29-rc2-git2] compilation warnings
Message-ID: <20090127094628.670eca16@hyperion.delvare>
In-Reply-To: <s5hbpttcigu.wl%tiwai@suse.de>
References: <497EB491.6080904@numericable.fr>
	<s5hbpttcigu.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 08:32:17 +0100, Takashi Iwai wrote:
> At Tue, 27 Jan 2009 08:15:29 +0100,
> Rufus & Azrael wrote:
> > 
> > Here are my compilation warnings for fresh 2.6.29-rc2-git2 kernel :
> > 
> > > sound/pci/hda/hda_codec.c: In function ‘get_empty_pcm_device’:
> > > sound/pci/hda/hda_codec.c:2544: attention : ‘dev’ may be used 
> > > uninitialized in this function
> 
> A bogus warning.  Ignore this.

No matter how bogus it is, it should be fixed. Otherwise this is
wasting the time of users and developers over and over again.

-- 
Jean Delvare
