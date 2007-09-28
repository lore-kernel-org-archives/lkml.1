Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbXI1KDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbXI1KDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbXI1KDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:03:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:49052 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbXI1KDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cu3F7NZvc1FeIZ/1d2wrZKlwRWGGcp1/5dN7VXW8x/KXtibyW/M8KULaoBJSVqJx8roh78PJy6M+1NkPA/HgL/r4Z2Z7J9kBE/30d/0HIJoWE/w9lzlsJKE+5EozBAt9YFnlY2WIBWNQj3ZWw2uib6yOwuBHoMCHZPndApLr0hI=
Message-ID: <46FCD114.5060001@gmail.com>
Date: Fri, 28 Sep 2007 03:01:56 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mark Lord <liml@rtr.ca>, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, michal.k.k.piotrowski@gmail.com,
       bryan@arbores.ca, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata drain fifo on stuck DRQ HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com>	<20070905095327.6277d054.akpm@linux-foundation.org>	<46DEE617.4050004@rtr.ca>	<46E0A253.7060803@gmail.com>	<46E154DE.2060602@rtr.ca>	<46FB563A.80108@gmail.com>	<20070927193701.6230d77f@the-village.bc.nu>	<46FC3D7D.90009@gmail.com>	<46FC3FDD.5060201@pobox.com>	<46FC423C.2050206@gmail.com>	<46FC7B72.2030103@rtr.ca>	<46FCCDEC.20200@gmail.com> <20070928025644.7ee4af0c.akpm@linux-foundation.org>
In-Reply-To: <20070928025644.7ee4af0c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Nacked-by: scripts/checkpatch.pl

Mark, it seems you'll have to get ACK from this dude first.  :-)

-- 
tejun
