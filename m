Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYF2VH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYF2VH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 17:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYF2VHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 17:07:48 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52665 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbYF2VHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 17:07:47 -0400
Date: Mon, 30 Jun 2008 00:07:43 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Justin Mattock <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10954] hda_intel: azx_get_response timeout, switching to
	polling mode: last cmd=0x011f000c
Message-ID: <20080629210743.GL19430@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Justin Mattock <justinmattock@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik> <X8mbwW6K81I.A.9LE.N79ZIB@albercik> <dd18b0c30806291328o55d1be25t4d692344bbc3d129@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd18b0c30806291328o55d1be25t4d692344bbc3d129@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 08:28:58PM +0000, Justin Mattock wrote:
> On Sun, Jun 29, 2008 at 6:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10954
> > Subject         : hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
> > Submitter       : Justin Mattock <justinmattock@gmail.com>
> > Date            : 2008-06-21 2:05 (9 days old)
> > References      : http://marc.info/?l=linux-kernel&m=121401399622190&w=4
> >
> >
> >
> 
> yes; still seeing this pop up,(problem is I can't reproduce this)

This happened to me a few times a while back. It happened when watching
videos with mplayer. It only occured sometimes when switching from one
video file to the next. I haven't seen it in a while though.

Right now I have the HDA power save timeout set to 2 seconds. It is
possible I had it set to 1 second when I saw the problem, however I
can't be absolutely certain about that.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
