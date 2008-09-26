Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYIZRUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYIZRUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 13:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYIZRUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 13:20:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:14809 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYIZRUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 13:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=j1dq9/opL/Hvr+iwFlGO6mI+4MLqH9Ue9UM7UoCgWwgFw9HeMBg+daXjzhEGDgefux
         utEQcqjWpmxzjtzEIVfnSQBybEomq437htXQ+lTykku4PkTI3QHQr963YUt0KcWa3/0j
         yTLd83cf7iXbJ4o50EEL04oMomyQFMXhAJRZM=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Date: Fri, 26 Sep 2008 19:19:52 +0200
User-Agent: PLD Linux KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net> <48DCC691.30205@imap.cc> <20080926153634.GD21528@kroah.com>
In-Reply-To: <20080926153634.GD21528@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809261919.52382.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2008, Greg KH wrote:
> On Fri, Sep 26, 2008 at 01:25:05PM +0200, Tilman Schmidt wrote:
[...]
> > - http://acx100.sourceforge.net/
>
> I think this one has some dubious legal issues involved, and I can't
> take it at this time :(

Is this only about drivers? What about for example apparmor?

> thanks,
> greg k-h

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
