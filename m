Return-Path: <linux-kernel-owner+w=401wt.eu-S1031629AbXEAJjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031629AbXEAJjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031630AbXEAJjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:39:19 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:57082 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031629AbXEAJjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:39:18 -0400
Date: Tue, 1 May 2007 11:39:16 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: Jon Burgess <jburgess777@googlemail.com>
Cc: linux-dvb@linuxtv.org, v4l-dvb-maintainer@linuxtv.org,
       Markus Rechberger <mrechberger@gmail.com>, linux-kernel@vger.kernel.org,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [PATCH] Re: More than 2Gb problem (dvb related) ?
Message-ID: <20070501093916.GB6895@gmail.com>
References: <20070427111047.GB10284@gmail.com> <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com> <1177711220.26292.20.camel@localhost.localdomain> <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com> <1177780652.7152.14.camel@localhost.localdomain> <1177791277.5170.11.camel@localhost.localdomain> <20070430165232.GA6754@gmail.com> <1177956316.4752.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1177956316.4752.13.camel@localhost.localdomain>
X-Operating-System: Linux 2.6.21
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 07:05:16PM +0100, Jon Burgess wrote:

> I'm currently using 2.6.21 + x86_64-mm-vmalloc-32.patch with the v4l-dvb
> drivers. I need to use the v4l-dvb tree in order to get the IR remote
> working reliably. This combination compiles and works OK for me.

You are lucky :)

They are still some bugs with this setup : after some time of inactivity
I can't use vdr anymore, and killing it, I got a :

[vdr] <defunct>

which prevent me from unloading the modules, reload them and restart
vdr...

Thank,
-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
