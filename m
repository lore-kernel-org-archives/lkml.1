Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbXEAUDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbXEAUDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXEAUDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:03:21 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:53087 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753144AbXEAUDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:03:21 -0400
Date: Tue, 1 May 2007 22:03:18 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-dvb@linuxtv.org, Jon Burgess <jburgess777@googlemail.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: [linux-dvb] [PATCH] Re: More than 2Gb problem (dvb related) ?
Message-ID: <20070501200318.GA6669@gmail.com>
References: <20070427111047.GB10284@gmail.com> <75b66ecd0704271506x595dfb6bqe0ef4fd153818501@mail.gmail.com> <1177780652.7152.14.camel@localhost.localdomain> <200705011758.42921@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705011758.42921@orion.escape-edv.de>
X-Operating-System: Linux 2.6.21
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 05:58:42PM +0200, Oliver Endriss wrote:

> Has anyone a problem with this patch?
> If not I'll apply it tomorrow...

The patch seems fine, but incomplete : it allows budget-ci to work, but
don't allow cx88 cards to works.
-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
