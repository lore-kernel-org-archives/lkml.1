Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbYIEXOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbYIEXOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYIEXO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:14:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbYIEXO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:14:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: Regression: SATA disk double spin-off during hibernation on hp nx6325
Date: Sat, 6 Sep 2008 01:18:37 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org, trenn@suse.de,
       htejun@gmail.com, hancockr@shaw.ca, linux-kernel@vger.kernel.org,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200809041605.22055.rjw@sisk.pl> <200809060025.20039.elendil@planet.nl>
In-Reply-To: <200809060025.20039.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809060118.38493.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of September 2008, Frans Pop wrote:
> On Thursday 04 September 2008, Rafael J. Wysocki wrote:
> > I have uploaded a new version of the patch into the Bugzilla:
> > http://bugzilla.kernel.org/attachment.cgi?id=17618&action=view
> 
> This version does not work for me, possibly because I use a different hard 
> disk driver (ata_piix instead of sata_sil)?
> 
> I've seen there are later versions of the patch, but as the comments 
> mention that 2510p was removed from those I haven't tested them.
> 
> > (also please attach dmesg output to the Bugzilla entry)
> 
> Added.

Thanks.  There's a new patch for you to test in there already. :-)

Rafael
