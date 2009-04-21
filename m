Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZDUCig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZDUCig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 22:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZDUCi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 22:38:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:8080 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDUCi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 22:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mKNAKAySn7Lal1xh9sEbnzLRpqAGU79w9QelwXcXN19F5wRljCCuKZp8bVNEhOXwRo
         E7JULYgt6+gJmNFH/963grvQ+O08njUqkZiMr9F4ZoRM12McFRYaC9dVWSEgsd+pzn7X
         yyIb7CrihBZl3EyHzZeW3aXJAHQJtlpoQynwk=
Subject: Re: [patch 08/14] input: PCAP2 based touchscreen driver
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>, eric.y.miao@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, ao2@openezx.org
In-Reply-To: <20090421021811.GD13617@dtor-d630.eng.vmware.com>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org>
	 <20081121170518.GA4416@USFSHXP-002051>
	 <20081122000047.GB28067@dodger.lab.datenfreihafen.org>
	 <20090421021811.GD13617@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Apr 2009 23:38:41 -0300
Message-Id: <1240281521.25090.6.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Seg, 2009-04-20 às 19:18 -0700, Dmitry Torokhov escreveu:
> What is the status of PCAP support? Is it going to be merged in
> mainline? I am holding the touchscreen driver in my queue because
> it requires linux/mfd/ezx-pcap.h which is not in mainline yet...
> 
> Should I drop the driver? Is it going to be merged through some
> other tree?

Hi Dmitry,

Please drop it. There is still a lot of work needed to get our core PCAP
driver in shape for mainline.

Thanks!

-- 
Daniel Ribeiro

