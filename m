Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbYDBWVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbYDBWVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYDBWVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:21:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55403 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbYDBWVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:21:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: suspend
Date: Thu, 3 Apr 2008 00:21:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com> <200804021939.46733.rjw@sisk.pl> <dd18b0c30804021218t700484faua57a46e237ea581f@mail.gmail.com>
In-Reply-To: <dd18b0c30804021218t700484faua57a46e237ea581f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804030021.09325.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of April 2008, Justin Mattock wrote:
> Hello; I did some testing with the suspend and it seems the mighty
> mouse is being claimed by something before bluetooth daemon can claim
> it. the infrared device gives me no response even after issuing
> killall lirc and lircd and restarting the daemons,
> I'm able to get uvcvideo working after a rrmod uvcvideo then a
> modprobe uvcvideo then I'm able to use gmplayer tv:// -vf mirror to
> view the camera. with appletouch i have to ctrl,alt,del then rmmod
> appletouch then modprobe and startx for the scroll function to work
> again.
> 
> with sata = ata3.01: revalidation failed (errno=-2) I suspended
> simultaneously, on the third time this seems to show up.
> 
> Ill send the dmesg from the three suspends as soon as I locate the
> e-mail address to  the Sata people.

Please just attach it here.

Thanks,
Rafael
