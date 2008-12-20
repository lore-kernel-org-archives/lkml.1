Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYLTQ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYLTQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 11:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYLTQ4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 11:56:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:9865 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYLTQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 11:56:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=aNfZJxJs4FnHRCO5ElWtbsQJJnry/ewlNRnHEk7ehVkRAySayAcErS3hLvnn8f6D9d
         ws1iQVzbQUPZA33spJ1smfPyxKMlol1VW/JsNuI2zYRdKFfPiL+2SNEUF5zS6Vq24Lvd
         /ywbe/1zufYNcvJJJ2hA5XI3hEvbumDEfink0=
Message-ID: <494D239B.10800@gmail.com>
Date: Sat, 20 Dec 2008 17:55:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Hannes Eder <hannes@hanneseder.net>, Ben Dooks <ben-linux@fluff.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH] HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER
References: <4947a48f.08b6660a.34ca.ffffa1e8@mx.google.com>  <20081216155822.GD12431@fluff.org.uk>  <alpine.LNX.1.10.0812161659580.21089@jikos.suse.cz>  <20081216194113.GF12431@fluff.org.uk> <154e089b0812161144x3c9579f5g8731b616fde6484c@mail.gmail.com> <494B5BC4.100@gmail.com> <alpine.LNX.1.10.0812191037110.26265@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0812191037110.26265@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> BTW while we are at it -- what is the status with module-init-tools? Has 
> the support been merged already?

As far as I can see, not yet. Jon, what's the status of hid bus support in
m-i-t, please?
