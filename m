Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZGYPyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZGYPyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 11:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZGYPyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 11:54:46 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4141 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZGYPyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 11:54:45 -0400
Subject: Re: [PATCH] scsi: remove superfluous NULL pointer check from
 scsi_kill_request()
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
       corbet@lwn.net, eteo@redhat.com
In-Reply-To: <1248536538.20477.2.camel@Joe-Laptop.home>
References: <200907261629.26529.bzolnier@gmail.com>
	 <1248536538.20477.2.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 08:54:41 -0700
Message-Id: <1248537281.20477.8.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-25 at 08:42 -0700, Joe Perches wrote:
> On Sun, 2009-07-26 at 16:29 +0200, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Apologies for the empty message.  I was attempting
to tell Bartomiej his computer time is off but had
one too many keys pressed and the message got sent
to all before editing.

