Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYILSVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYILSVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 14:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYILSVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 14:21:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38078 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753000AbYILSVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 14:21:38 -0400
Date: Fri, 12 Sep 2008 14:21:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bob Copeland <me@bobcopeland.com>
cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       <bogdano@mandriva.com.br>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: Partition check considered as error is breaking mounting in
 2.6.27
In-Reply-To: <b6c5339f0809121059s2949a887q81de84ac6ca3a2d7@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809121420240.14509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Bob Copeland wrote:

> On Fri, Sep 12, 2008 at 1:36 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> I don't know if this change of behaviour in 2.6.27 is desired (not creating
> >> partition nodes if its size exceeds media size).
> >
> > I have to believe that it _is_ desired.  Why else would that commit
> > have been merged?
> 
> Several people objected to similar patches when they were posted on
> LKML in the past, usually for the reason "this breaks my forensics use
> case."  I guess no one objected this time around.
> 
> http://marc.info/?l=linux-kernel&m=116069718613683&w=2
> 
> (I don't have an opinion, I'm just providing collective memory.)

Well, Herton can object and ask to have the offending commit reverted.

Alan Stern

