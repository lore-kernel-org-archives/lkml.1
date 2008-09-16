Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYIPMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYIPMuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYIPMum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:50:42 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:42948 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYIPMul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=M3o8/bbWp2ZBtl8SZuTorR5PrROhR7oVuNoOKUrsxdEo6SGqQWmp3lGS5qqJ/Fp2jS
         /IrfMNarFeWpOpD2Vn5kVrQphiXFabXXM1eeE295/fWGXaaKnqrpIJhA0izwKYdqpVkq
         GaNLqoVR4MZ/w5p2Odm0h9X3YBJb22NjT9VU8=
Message-ID: <ab40e9c0809160550q411507aeledae30a9f835d09d@mail.gmail.com>
Date: Tue, 16 Sep 2008 14:50:38 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: looking for a function
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I am looking for a function that can show me the current thread is
running on which cpu.

e.g I am using pthread to write a multithreaded program, in each
thread I would like to insert such kind of function so that I can know
on which cpu this thread is running on.

which function should be used?

thanks for the help!!

best regards,



Yang
