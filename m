Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZFVJ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZFVJ3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZFVJ30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:29:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:56204 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZFVJ3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:29:25 -0400
Date: Mon, 22 Jun 2009 11:29:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
In-Reply-To: <20090620120357.GA11272@gallifrey>
Message-ID: <alpine.LNX.2.00.0906221125540.7457@wotan.suse.de>
References: <20090613230842.GA18347@gallifrey> <4A349B67.1070603@zytor.com> <20090614122734.GA1499@gallifrey> <alpine.LRH.2.00.0906161126330.31685@twin.jikos.cz> <20090617193442.GA31944@gallifrey> <alpine.LNX.2.00.0906180126260.7457@wotan.suse.de>
 <20090620120357.GA11272@gallifrey>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009, Dr. David Alan Gilbert wrote:

> > > > Booting with 'i8042.debug' will spit some more output into dmesg, which 
> > > > might help us to see if i8042 is really properly initialized, or something 
> > > > strange is going on during initialization.
> > > Please find below the new dmesg created by appending i8042.debug; this was
> > > taken from a slightly newer build of the same source kernel that I reported; this
> > > build just had a few more things configured out (parallel port) but exhibits
> > > the same symptom.
> <old dmesg removed>
> > Is there any change if you boot with 'i8042.noaux' kernel command-line 
> > parameter?
> Yes, with i8042.noaux it works; dmesg snippet included below.

Could you please provide an output of 'dmidecode -t system' command?

Thanks,

-- 
Jiri Kosina
SUSE Labs
