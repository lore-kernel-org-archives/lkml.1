Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbXA3QVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbXA3QVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbXA3QVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:21:46 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:34445 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbXA3QVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:21:46 -0500
Subject: Re: [Bluez-devel] trouble with sysfs and bluetooth
From: Marcel Holtmann <marcel@holtmann.org>
To: Oliver Neukum <oliver@neukum.name>
Cc: BlueZ development <bluez-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, maxk@qualcomm.com
In-Reply-To: <200701301713.01942.oliver@neukum.name>
References: <200701301135.53178.oliver@neukum.name>
	 <1170154328.27519.27.camel@violet>  <200701301713.01942.oliver@neukum.name>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 17:21:09 +0100
Message-Id: <1170174069.27519.67.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.6 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

> > do you see them also with the plain vanilla 2.6.20-rc6 kernel or are
> > these only coming up in Greg's tree?
> 
> they are limited to Greg's tree.

my first guess would that there is something wrong with Greg's tree or
that one of this patches changes some behavior of the driver model.

Regards

Marcel


