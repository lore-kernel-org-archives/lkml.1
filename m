Return-Path: <linux-kernel-owner+w=401wt.eu-S1763249AbXGRDFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763249AbXGRDFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 23:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXGRDFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 23:05:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:18642 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbXGRDFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 23:05:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jRb1WIO8zNV0XZLH3mSAr/RP9B+yz5NZjyap94sGbdNf2AGGzMWHKjuWOZnGi6DpRPQAem44IG2mlIj/3wtuKai2g0HPpIykwoSGnp07iakOls6CfBLa3VClX5sR+ZZraZq8snaNAkrLfC6bmyGbaz2L6VIF6nurIZIlzT3Jvsk=
Message-ID: <469D835F.4060606@gmail.com>
Date: Wed, 18 Jul 2007 12:05:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
References: <20070715124232.4e371bf9@hyperion.delvare>	<20070717034844.GB11602@suse.de>	<20070717131255.71b7e72e@hyperion.delvare>	<20070717183652.GG9702@suse.de> <20070717230530.64d9a896@hyperion.delvare>
In-Reply-To: <20070717230530.64d9a896@hyperion.delvare>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry about late response.  -EWASPUBLICHOLIDAY.  That's something I've
broken apparently.  Will fix soon.

Thanks.

-- 
tejun
