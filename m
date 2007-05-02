Return-Path: <linux-kernel-owner+w=401wt.eu-S2993371AbXEBPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993371AbXEBPcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993373AbXEBPcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:32:52 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45943 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2993372AbXEBPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:32:51 -0400
Date: Wed, 2 May 2007 17:32:49 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
In-Reply-To: <20070502152906.GA29642@infradead.org>
Message-ID: <Pine.LNX.4.62.0705021731580.3706@pademelon.sonytel.be>
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org>
 <20070425112133.4ae86399.randy.dunlap@oracle.com>
 <20070425143011.57247c1d.akpm@linux-foundation.org>
 <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com>
 <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org>
 <20070428030805.GA13331@redhat.com> <Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
 <20070502152906.GA29642@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Christoph Hellwig wrote:
> On Wed, May 02, 2007 at 04:28:27PM +0200, Geert Uytterhoeven wrote:
> >   - Check for GNU extension __FUNCTION__
> 
> __FUNCTION__ is prefered  over __func__

Is there a reason for that?
  - __FUNCTION__ is a GNU extension
  - __func__ is C99
  - __func__ is shorter to type ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
