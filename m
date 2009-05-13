Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZEMNAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZEMNAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZEMM76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:59:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47856 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753335AbZEMM76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:59:58 -0400
Date: Wed, 13 May 2009 13:59:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090513135926.41db4f2c@lxorguk.ukuu.org.uk>
In-Reply-To: <1242217342.9974.10.camel@localhost.localdomain>
References: <20090509143742.GA27663@kroah.com>
	<1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil>
	<20090511175626.GA4758@kroah.com>
	<1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
	<ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
	<1242132344.31807.48.camel@localhost.localdomain>
	<ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com>
	<1242142528.31807.80.camel@localhost.localdomain>
	<ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com>
	<1242168913.6711.9.camel@poy>
	<1242217342.9974.10.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Had a poke at the crash - seems to be a devtmpfs bug at the moment.
