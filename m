Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZLKMgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZLKMgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZLKMgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:36:04 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:51800 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZLKMgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=UijPiUEd2/mR3anK0QyRHpihTr9TcdzHc1S0B/fB34YHnx+ElCIgmlukStJhp9BSro
         saP7ll16mblEIv3uyxo2Pa9Ao2A0Sx5pnQVphFxSecXSrTKILl6XIRmlnyr6cicmHK6B
         TIyr97Ysm6RytSh4tC6m2p4pLYzxJ4/QJ10/E=
Date: Fri, 11 Dec 2009 13:36:03 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
Message-ID: <20091211133603.46bec686@strolchi.home.s3e.de>
In-Reply-To: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.1; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Dec 2009 15:21:33 +0100
Stefan Seyfried <stefan.seyfried@googlemail.com> wrote:

> From: Stefan Seyfried <seife@sphairon.com>
> 
> The following two trivial patches add support for this device to
> zd1211rw (ejecting the virtual USB drive) and ar9170usb (that drives
> the WLAN chip inside).

Is anyhting wrong with those?
Are those too trivial and "USB only" and thus better suited for direct
submission to Greg?

Thanks,

	Stefan
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
