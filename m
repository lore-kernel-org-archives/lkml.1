Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbXJ3Ovl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbXJ3Ovl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXJ3Ove
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:51:34 -0400
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:62341 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbXJ3Ovd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:51:33 -0400
From: CIJOML <cijoml@volny.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Phis in /proc/bus/input/devices same for all devices?
Date: Tue, 30 Oct 2007 15:51:13 +0100
User-Agent: KMail/1.9.7
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
References: <200702212313.30359.cijoml@volny.cz> <200710292329.54895.cijoml@volny.cz> <200710292352.39396.dmitry.torokhov@gmail.com>
In-Reply-To: <200710292352.39396.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710301551.14377.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

are there any patches available to support uniq? I really want to have easy 
setup of my 2 same diNovo desktops keyboarad sets each with different keymap 
etc...

Dimitri thank you a lot for support so I can push Xguys now ;)

Michal

Dne út 30. øíjna 2007 Dmitry Torokhov napsal(a):
> Hi Michal,
>
> On Monday 29 October 2007, CIJOML wrote:
> > Dne èt 22. února 2007 Dmitry Torokhov napsal(a):
> > > Plus I
> > > will export uniq in /proc/bus/input/devices and then yo can ask X guys
> > > to allow matching on uniq as well.
> >
> > Hi Dmitri,
> >
> > I watched at 2.6.23 and this is still not done yet. Are there any patches
> > available to use???
>
> Input core does export uniq in /proc/bus/input/devices so now it is
> up to individual drivers to populate this field in input_dev
> structure.


