Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbXKOAV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbXKOAV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 19:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbXKOAVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 19:21:46 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:41121 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755890AbXKOAVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:21:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=r0JkADGL4VTAWr8bjIWLSKmaK+rdS49B5In3P/1V8Ho7xu0pjRVnf7aRlZkdwfIBzxmiMbFC0orfG1sBYbOm1BpXKcXMLFBgMtYVU9x1igwtilEM2OMQu/JRoHoSfzmiPURKq32hqThFdIoQ49fPAoe294eS47FOZSK1Mio+H9U=  ;
X-YMail-OSG: o9GKwaYVM1mZMjrEXhVtGII4Oy7QK6w8avZFbctKQHshXd9k
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression with tbench
Date: Thu, 15 Nov 2007 11:21:36 +1100
User-Agent: KMail/1.9.5
Cc: herbert@gondor.apana.org.au, clameter@sgi.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200711140927.39796.nickpiggin@yahoo.com.au> <20071114114844.GA13927@gondor.apana.org.au> <20071114.154616.46285694.davem@davemloft.net>
In-Reply-To: <20071114.154616.46285694.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711151121.37080.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 10:46, David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Wed, 14 Nov 2007 19:48:44 +0800

> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Applied and I'll queue it up for -stable too.

Good result. Thanks, everyone!
