Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbXIQQaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbXIQQaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXIQQ3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:29:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:9181 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbXIQQ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OSk5luflUgTqh9TGgQs/uQ8zbPCWXJjiQt0PzSEvBH+WJbg2o6HR/aeiO91f/Atw9J43ooSUmYQeMKdCqCNRaFJs1fCUpXqdX4P2Q3HPdTSps2JL2bZXh1Dhrv4HyLRPK2lw4HZ1Fia4+Ooh/LSTHFoZ+A+nQwhxHedN1r/odgw=
Message-ID: <c5b2c05b0709170929i7674a8fcl64ab60cd5f0e727b@mail.gmail.com>
Date: Mon, 17 Sep 2007 18:29:51 +0200
From: "Primiano Tucci" <p.tucci@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Linux Network Load Balancing is out!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
I've just released my first beta of Linux Network Load Balancing....
it's a driver (+ userland tool) to make decentered load balancing
clusters.

I hope someone is interested in the project and could do some testing
in decent environments (I've just done some "laboratory" test in a 3
virtualized node cluster environment, but nothing more than this).

Sources and some documentation on http://lnlb.sourceforge.net/

Greetings,
Primiano Tucci
