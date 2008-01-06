Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYAFVbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYAFVbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYAFVbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:31:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:14397 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYAFVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=KC8zX2ZAOV4Ei9XuyUvUAVE9cVr+JUh+RWE2DnunxIJsuWgeLBAmrWS7jr6W83F4tcLmsSgGNR8UoCKBF6Y2q1mu3qQTcjG8OkDwbKzc/UP/FsKeLtjwHH5kvi75exZqCsjWOWIWo6HBO6AZxi6u8hFru+IUtBow/v8zShwQhZY=
Message-ID: <4781486C.6030705@gmail.com>
Date: Sun, 06 Jan 2008 23:30:20 +0200
From: Mehmet Kemal EROL <mehmet.kemal.erol@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071208 Thunderbird/2.0.0.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
References: <fa.o9uy6Qaq3PtHs2Z9lAKGUKvD85I@ifi.uio.no> <fa.1kDEq2SPE3FqpM5Mfw9CVGbvVdY@ifi.uio.no> <fa.hIZ5+XhGRugySB/HuLxr5qd6gAY@ifi.uio.no> <fa.iefWPg3R6g5Pnm/ktSCK9XWVFVw@ifi.uio.no> <fa.FhpaleM/osLTMJ85/PuxjxyJeGI@ifi.uio.no> <fa.MP5rgMp4TS2+Cfemd/uFOQOuquQ@ifi.uio.no> <477D9B6E.7060000@shaw.ca> <477D9D66.3080502@tlinx.org> <477DA05F.4080503@shaw.ca> <47813926.6010908@tlinx.org>
In-Reply-To: <47813926.6010908@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh:

> 
> Seagate would
> remove those features -- especially since they are mentioned on 
> Seagate's drive
> information page as being supported features.
> 

Since you're there ... you might want to download `Seagate's SeaTools'
and (if) give the hdd's controller a try ... ;)

-- 
Esenlikle   <~>   Mehmet Kemal

_/_/  IBM Pollyanna Principle:
_/    Machines should work,
_/    People should think...

