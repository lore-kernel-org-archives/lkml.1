Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYKNW23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYKNW23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYKNW2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:28:19 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:6097 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYKNW2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:28:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dwq8AQdVhNrhBNjkbVqTzlnRfyfWVIXZyTgw5yayKgzNLIbbTxCfO9tEKRc0P/smA1
         7hic+J8A2jPvZ5xt3z7RGAYYI10dg1WxSW9ifNyNPuqQG7MS5TCdeBL119ewkiLICXps
         BXzZn27c84vWbwsCkN3pF2ebclyGIBnGXIrG4=
Message-ID: <3aaafc130811141428ta97f929va8c62cbcdbc731f7@mail.gmail.com>
Date: Fri, 14 Nov 2008 17:28:17 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Can you add the staging tree to -next?
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081114173258.GC22980@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081112235600.GA27554@kroah.com>
	 <Pine.LNX.4.64.0811140825410.11953@anakin>
	 <20081114173258.GC22980@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There also seem to be a lot of build errors that no one hacking on
staging has seen before being threshed out by all the randconfig tests
done on -next, which will help a lot if we want the staging drivers to
actually go anywhere.

~J.R.
