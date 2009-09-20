Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZITVNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZITVNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZITVNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:13:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:60487 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZITVNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eRytb9jEz8uFVq0A3xULvd63OkCkveNGmdlWz5YaIpBODcd1jCojVUwdcM7Iq2/qjp
         DASjKq1mSuTLjLQBcN1F+cgA7kLPC5WsN/WxI31HkCJ+GEzmF9bTAngx8adPfcJ3J66Z
         DcZybxzp/y4mQvrSMTPry+QH2wO+joArLR7no=
Message-ID: <4AB69AFF.1070902@gmail.com>
Date: Sun, 20 Sep 2009 23:13:35 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"
 ?
References: <4AB630AD.90207@imap.cc> <20090920150549.GC11621@kroah.com> <4AB65FD9.3020004@imap.cc>
In-Reply-To: <4AB65FD9.3020004@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Btw, I just found another bugzilla entry describing essentially
> the same problem:
> 
> Bug 10868 -  Oops on loading ipaq module since 2.6.26, prevents use of device
> http://bugzilla.kernel.org/show_bug.cgi?id=10868
> 
> Its status is - you'll never guess - "CLOSED CODE_FIX"!
> 
> Quite a persistent little fella, it seems.
> 

FYI, there are hundreds of kerneloops reports for ipaq_open...
(from 2.6.25 to 2.6.31)
http://kerneloops.org/guilty.php?guilty=ipaq_open&version=2.6.31-release&start=2064384&end=2097151&class=oops

Marcin
